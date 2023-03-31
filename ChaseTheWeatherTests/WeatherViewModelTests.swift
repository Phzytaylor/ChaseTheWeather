//
//  WeatherViewModelTests.swift
//  ChaseTheWeatherTests
//
//  Created by Taylor Simpson on 3/30/23.
//

import XCTest
@testable import ChaseTheWeather

class WeatherViewModelTests: XCTestCase {
    
    // ran out of time for other tests, but the other view model tests would be similar
    func testSearchWeatherSuccess() async throws {
        let mockWeatherAPIClient = MockWeatherAPIClient()
        let mockLocationHandler = MockLocationHandler()
        let viewModel = await WeatherViewModel.createAsync(locationHandler: mockLocationHandler, weatherClient: mockWeatherAPIClient)
        
        let expectedWeatherData = WeatherData(main: Main(temp: 298.15, feelsLike: 297.93, pressure: 1005, humidity: 54, tempMin: 297.58, tempMax: 299.16, seaLevel: 12 , grndLevel: 13), weather: [Weather(id: 801, main: "Clouds", description: "few clouds", icon: "02d")], name: "Tokyo", coord: Coord(lon: 139.6917, lat: 35.6895), visibility: 10000, wind: Wind(speed: 2.06, deg: 140, gust: 1.2), rain: Rain(oneHour: 12.3, threeHours: 13.3), snow: Snow(oneHour: 12.3, threeHours: 13.3), dt: 1680228996, sys: .init(type: 2, id: 268395, message: "message", country: "JP", sunrise: 1680208212, sunset: 1680253247), timezone: 32400, id: 1850144)
        mockWeatherAPIClient.currentWeatherResult = .success(expectedWeatherData)
        
        await viewModel.searchWeather(byCityName: "San Francisco")
        
        // Need to learn a little more about MainActor... this is a little janky
        await expectation(description: "Waiting for weather data") { exp in
            Task {
                let weatherData = await viewModel.weatherData
                XCTAssertEqual(weatherData, expectedWeatherData)
                exp.fulfill()
            }
        }
        
        
    }
    
    // this is similar to what I have seen at work and it lets me wait
    func expectation(description: String, timeout: TimeInterval = 2, file: StaticString = #filePath, line: UInt = #line, execute: (XCTestExpectation) -> Void) async {
            let exp = XCTestExpectation(description: description)
            execute(exp)
        
        }
    
    
}
