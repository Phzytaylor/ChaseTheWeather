//
//  ViewModel.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/22/23.
//

import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: NSObject, ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var forecastData: ForcastData?
    @Published var locationPermissionRequested: Bool = false
    @Published var errorMessage: String?
    @Published var locationError: IdentifiableError?
    @Published var timeOfDay: Double = 0.0
    
    private let weatherClient: WeatherAPIClientProtocol
    private var locationHandler: LocationHandler
    private let userDefaults: SendableUserDefaults
    private let lastSearchedCityKey = "lastSearchedCity"
    private let savedCitiesKey = "savedCities"
    
    var weatherConditions: WeatherData.WeatherConditions {
        if let weather = weatherData?.weather.first {
                return WeatherData.WeatherConditions(weather: weather)
            } else {
                return .unknown
            }
        }
    
    init(locationHandler: LocationHandler, weatherClient: WeatherAPIClientProtocol = WeatherAPIClient(), userDefaults: SendableUserDefaults) {
        self.locationHandler = locationHandler
        self.weatherClient = weatherClient
        self.userDefaults = userDefaults
        super.init()
        if let city = getLastSearchedCity() {
            Task {
                await self.searchWeather(byCityName: city)
                await self.searchForecast(byCityName: city)
            }
        } else {
            setupLocationHandler()
        }
    }

    
        var formattedTime: String {
            let start = Calendar.current.startOfDay(for: Date.now)
            let advanced = start.addingTimeInterval(timeOfDay * 24 * 60 * 60)
            return advanced.formatted(date: .omitted, time: .shortened)
        }
    
    static func createAsync(locationHandler: LocationHandler, weatherClient: WeatherAPIClientProtocol = WeatherAPIClient(), userDefaults: UserDefaults = .standard) async -> WeatherViewModel {
            let sendableUserDefaults = await SendableUserDefaults.createAsync(userDefaults: userDefaults)
            return WeatherViewModel(locationHandler: locationHandler, weatherClient: weatherClient, userDefaults: sendableUserDefaults)
        }
    
    private func setupLocationHandler() {
        locationHandler.onLocationUpdate = { [weak self] location in
            Task {
                await self?.searchWeather(byLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                await self?.searchForecast(byLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
        
        locationHandler.onLocationError = { [weak self] error in
            self?.locationError = IdentifiableError(message: "Location error: \(error.localizedDescription)")
        }
        
        locationHandler.requestPermission()
    }
    
    // could cache this call, but weather current weather may change quickly especially when severe
    func searchWeather(byCityName cityName: String) async {
        do {
            let weatherData = try await weatherClient.fetchCurrentWeather(location: .cityName(city: cityName))
            self.weatherData = weatherData
            await updateTime()
            saveLastSearchedCity(cityName)
        } catch {
            errorMessage = "Error fetching weather data."
        }
    }
    
    func searchForecast(byCityName cityName: String) async {
        do {
            let forecaseData = try await weatherClient.fetchFiveDayForecast(location: .cityName(city: cityName), count: 8)
            self.forecastData = forecaseData
        } catch {
            errorMessage = "Error fetching weather data."
        }
    }
    
    func searchForecast(byLatitude latitude: Double, longitude: Double) async {
        do {
            let forecastData = try await weatherClient.fetchFiveDayForecast(location: .coordinates(latitude: latitude, longitude: longitude), count: 8)
            self.forecastData = forecastData
        } catch {
            errorMessage = "Error fetching weather data."
        }
    }
    
    func searchWeather(byLatitude latitude: Double, longitude: Double) async {
        do {
            let weatherData = try await weatherClient.fetchCurrentWeather(location: .coordinates(latitude: latitude, longitude: longitude))
            self.weatherData = weatherData
            await updateTime()
        } catch {
            errorMessage = "Error fetching weather data."
        }
    }
    
    func updateTime() async {
        guard let weatherData = weatherData else {
            return
        }
        self.timeOfDay = await self.weatherData?.localTimeFraction(forLatitude: weatherData.coord.lat, longitude: weatherData.coord.lon) ?? 0
    }

    private func saveLastSearchedCity(_ cityName: String) {
        userDefaults.set(cityName, forKey: lastSearchedCityKey)
    }

    private func getLastSearchedCity() -> String? {
        return userDefaults.string(forKey: lastSearchedCityKey)
    }

    
    // using user defaults becase we are just storing single strings in an array and using them to make api calls
    func saveCity(name: String) {
        let savedCities = getCities()
        var cityNames = savedCities.map { $0.name }
        if !cityNames.contains(name) {
            cityNames.append(name)
            UserDefaults.standard.set(cityNames, forKey: savedCitiesKey)
        }
    }
    func getCities() -> [City] {
        let cities = UserDefaults.standard.stringArray(forKey: savedCitiesKey) ?? []
        
        return cities.map { City(name: $0) }
    }
    
    

}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = manager.location {
                Task {
                    await searchWeather(byLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
        default:
            break
        }
    }
}

extension WeatherData {
    
    func localTimeFraction(forLatitude latitude: Double, longitude: Double) async -> Double? {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            guard let timeZone = placemarks.first?.timeZone else { return nil }

            let now = Date()
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = timeZone
            var localComponents = calendar.dateComponents(in: timeZone, from: now)
            localComponents.timeZone = timeZone

            guard let localDate = calendar.date(from: localComponents),
                  let components = calendar.dateComponents([.hour, .minute, .second], from: localDate) as DateComponents?,
                  let hour = components.hour,
                  let minute = components.minute,
                  let second = components.second
            else {
                return nil
            }

            let secondsPassed = Double(hour * 3600 + minute * 60 + second)
            let totalSecondsInDay: Double = 24 * 60 * 60
            let fraction = secondsPassed / totalSecondsInDay
            return fraction
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }

}

