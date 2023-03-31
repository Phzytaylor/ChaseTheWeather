//
//  WeatherAPIClient.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/22/23.
//

import Foundation

protocol WeatherAPIClientProtocol {
    func fetchCurrentWeather(location: Location) async throws -> WeatherData
    func fetchFiveDayForecast(location: Location, count: Int?) async throws -> ForcastData
}

enum Location {
    case cityName(city: String, state: String? = nil, countryCode: String? = nil)
    case coordinates(latitude: Double, longitude: Double)
}

enum WeatherAPIClientError: Error {
    case invalidURL
    case invalidMockData
    case requestFailed(Int)
}

class WeatherAPIClient: WeatherAPIClientProtocol {
    private let apiKey = "<YOURAPIKEY>"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
            self.session = session
        }
    
    func fetchCurrentWeather(location: Location) async throws -> WeatherData {
        let locationString = buildLocationString(from: location)
        let url = try buildURL(endpoint: "/weather", parameters: "\(locationString)&appid=\(apiKey)&units=imperial")
        return try await fetchData(from: url)
    }
    
    func fetchFiveDayForecast(location: Location, count: Int? = 8) async throws -> ForcastData {
        let locationString = buildLocationString(from: location)
        let countString = count.map { "&cnt=\($0)" } ?? ""
        let url = try buildURL(endpoint: "/forecast", parameters: "\(locationString)\(countString)&appid=\(apiKey)&units=imperial")
        return try await fetchData(from: url)
    }
    
    private func buildLocationString(from location: Location) -> String {
        switch location {
        case .cityName(let city, let state, let countryCode):
            var locationString = "q=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            if let state = state {
                locationString += ",\(state.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            }
            if let countryCode = countryCode {
                locationString += ",\(countryCode)"
            }
            return locationString
        case .coordinates(let latitude, let longitude):
            return "lat=\(latitude)&lon=\(longitude)"
        }
    }


    private func buildURL(endpoint: String, parameters: String) throws -> URL {
        guard let url = URL(string: "\(baseURL)\(endpoint)?\(parameters)") else {
            throw WeatherAPIClientError.invalidURL
        }
        return url
    }

    
    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, urlResponse) = try await session.data(from: url)
        if let httpResponse = urlResponse as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            switch statusCode {
            case 200:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            case 401, 404, 429, 500, 502, 503, 504:
                throw WeatherAPIClientError.requestFailed(statusCode)
            default:
                throw WeatherAPIClientError.requestFailed(statusCode)
            }
        } else {
            throw WeatherAPIClientError.requestFailed(-1)
        }
    }
}

