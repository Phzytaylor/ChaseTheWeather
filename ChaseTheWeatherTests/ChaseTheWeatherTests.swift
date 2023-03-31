//
//  ChaseTheWeatherTests.swift
//  ChaseTheWeatherTests
//
//  Created by Taylor Simpson on 3/22/23.
//

import XCTest
import Foundation
@testable import ChaseTheWeather

class WeatherAPIClientTests: XCTestCase {
    func testFetchCurrentWeather() async throws {
        
        let expectedWeatherData = WeatherData(main: Main(temp: 298.15, feelsLike: 297.93, pressure: 1005, humidity: 54, tempMin: 297.58, tempMax: 299.16, seaLevel: 12 , grndLevel: 13), weather: [Weather(id: 801, main: "Clouds", description: "few clouds", icon: "02d")], name: "Tokyo", coord: Coord(lon: 139.6917, lat: 35.6895), visibility: 10000, wind: Wind(speed: 2.06, deg: 140, gust: 1.2), rain: Rain(oneHour: 12.3, threeHours: 13.3), snow: Snow(oneHour: 12.3, threeHours: 13.3), dt: 1680228996, sys: .init(type: 2, id: 268395, message: "message", country: "JP", sunrise: 1680208212, sunset: 1680253247), timezone: 32400, id: 1850144)

        let jsonData = try JSONEncoder().encode(expectedWeatherData)

        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let mockSession = MockURLSession(data: jsonData, urlResponse: urlResponse, error: nil)

        let apiClient = WeatherAPIClient(session: mockSession)

        let location = Location.cityName(city: "Tokyo")
        let fetchedWeatherData = try await apiClient.fetchCurrentWeather(location: location)

        XCTAssertEqual(fetchedWeatherData, expectedWeatherData)
    }
    
    func testFetchCurrentWeatherWithCoords() async throws {
        
        let expectedWeatherData = WeatherData(main: Main(temp: 298.15, feelsLike: 297.93, pressure: 1005, humidity: 54, tempMin: 297.58, tempMax: 299.16, seaLevel: 12 , grndLevel: 13), weather: [Weather(id: 801, main: "Clouds", description: "few clouds", icon: "02d")], name: "Tokyo", coord: Coord(lon: 139.6917, lat: 35.6895), visibility: 10000, wind: Wind(speed: 2.06, deg: 140, gust: 1.2), rain: Rain(oneHour: 12.3, threeHours: 13.3), snow: Snow(oneHour: 12.3, threeHours: 13.3), dt: 1680228996, sys: .init(type: 2, id: 268395, message: "message", country: "JP", sunrise: 1680208212, sunset: 1680253247), timezone: 32400, id: 1850144)

        let jsonData = try JSONEncoder().encode(expectedWeatherData)

        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let mockSession = MockURLSession(data: jsonData, urlResponse: urlResponse, error: nil)

        let apiClient = WeatherAPIClient(session: mockSession)

        let location = Location.coordinates(latitude: 139.6917, longitude: 35.6895)
        let fetchedWeatherData = try await apiClient.fetchCurrentWeather(location: location)

        XCTAssertEqual(fetchedWeatherData, expectedWeatherData)
    }
    
    
    func testFetchCurrentForecast() async throws {
        
        let expectedWeatherData = ForcastData(list: [.init(dt: 1680228996, main: .init(temp: 298.15, feelsLike: 297.93, pressure: 1005, humidity: 54, tempMin: 297.58, tempMax: 299.16, seaLevel: 12 , grndLevel: 13), weather: [.init(id: 801, main: "Clouds", description: "few clouds", icon: "02d")], clouds: Clouds(all: 75), wind: .init(speed: 2.06, deg: 140, gust: 1.2), visibility: 10000, pop: 2000, rain: .init(oneHour: 12.3, threeHours: 13.2), snow: .init(oneHour: 12.3, threeHours: 13.2))])

        let jsonData = try JSONEncoder().encode(expectedWeatherData)

        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let mockSession = MockURLSession(data: jsonData, urlResponse: urlResponse, error: nil)

        let apiClient = WeatherAPIClient(session: mockSession)

        let location = Location.cityName(city: "Tokyo")
        let fetchForecastData = try await apiClient.fetchFiveDayForecast(location: location)

        XCTAssertEqual(fetchForecastData, expectedWeatherData)
    }
    
    func testFetchCurrentForecastByCoords() async throws {
        
        let expectedWeatherData = ForcastData(list: [.init(dt: 1680228996, main: .init(temp: 298.15, feelsLike: 297.93, pressure: 1005, humidity: 54, tempMin: 297.58, tempMax: 299.16, seaLevel: 12 , grndLevel: 13), weather: [.init(id: 801, main: "Clouds", description: "few clouds", icon: "02d")], clouds: Clouds(all: 75), wind: .init(speed: 2.06, deg: 140, gust: 1.2), visibility: 10000, pop: 2000, rain: .init(oneHour: 12.3, threeHours: 13.2), snow: .init(oneHour: 12.3, threeHours: 13.2))])

        let jsonData = try JSONEncoder().encode(expectedWeatherData)

        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let mockSession = MockURLSession(data: jsonData, urlResponse: urlResponse, error: nil)

        let apiClient = WeatherAPIClient(session: mockSession)

        let location = Location.coordinates(latitude: 139.6917, longitude: 35.6895)
        let fetchForecastData = try await apiClient.fetchFiveDayForecast(location: location)

        XCTAssertEqual(fetchForecastData, expectedWeatherData)
    }
}

