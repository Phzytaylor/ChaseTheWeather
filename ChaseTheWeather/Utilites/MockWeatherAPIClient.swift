//
//  MockWeatherAPIClient.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/30/23.
//

import Foundation

class MockWeatherAPIClient: WeatherAPIClientProtocol {
    var currentWeatherResult: Result<WeatherData, Error>?
    var fiveDayForecastResult: Result<ForcastData, Error>?

    func fetchCurrentWeather(location: Location) async throws -> WeatherData {
        return try (currentWeatherResult ?? .failure(WeatherAPIClientError.invalidMockData)).get()
    }

    func fetchFiveDayForecast(location: Location, count: Int?) async throws -> ForcastData {
        return try (fiveDayForecastResult ?? .failure(WeatherAPIClientError.invalidMockData)).get()
    }
}



protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}


class MockURLSession: URLSessionProtocol {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    var statusCode: Int = 200

    init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }

        guard let data = data, let urlResponse = urlResponse else {
            fatalError("You must provide either data and urlResponse or error")
        }

        return (data, urlResponse)
    }
}





extension URLSession: URLSessionProtocol {}
