//
//  WeatherData.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/22/23.
//

import Foundation

struct WeatherData: Codable, Identifiable {
    let main: Main
    let weather: [Weather]
    let name: String
    let coord: Coord
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    
}

struct ForcastData: Codable {
    let list: [List]
    
}

struct List: Codable, Identifiable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind?
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let snow: Snow?
    
    var id: TimeInterval { dt }
    
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    let seaLevel: Int?
    let grndLevel: Int?
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Rain: Codable {
    let oneHour: Double?
    let threeHours: Double?
    
    private enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Snow: Codable {
    let oneHour: Double?
    let threeHours: Double?
    
    private enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let message: String?
    let country: String
    let sunrise: Int
    let sunset: Int
    
}

extension WeatherData {
    var weatherCondition: String? {
        return weather.first?.main.lowercased()
    }
}

extension WeatherData {
    enum WeatherConditions: String {
        case clear = "Clear"
        case clouds = "Clouds"
        case rain = "Rain"
        case snow = "Snow"
        case thunderstorm = "Thunderstorm"
        case unknown = "Unknown"
        
        init(weather: Weather) {
            switch weather.id {
            case 200...232:
                self = .thunderstorm
            case 300...321, 500...531:
                self = .rain
            case 600...622:
                self = .snow
            case 800:
                self = .clear
            case 801...804:
                self = .clouds
            default:
                self = .unknown
            }
        }
        
        
        func stormStrength(weather: Weather) -> Double {
            switch self {
            case .rain:
                if weather.id >= 500 && weather.id <= 504 {
                    return 0.2// Light to moderate rain
                } else if weather.id >= 520 && weather.id <= 531 {
                    return 0.5 // Heavy rain
                } else {
                    return 0.1 // Drizzle or very light rain
                }
            case .snow:
                if weather.id >= 600 && weather.id <= 602 {
                    return 0.3 // Light to moderate snow
                } else if weather.id >= 611 && weather.id <= 622 {
                    return 0.5 // Heavy snow or sleet
                } else {
                    return 0.1 // Light snow showers
                }
            default:
                return 0.0 // No rain or snow
            }
        }
    }
    
}


extension WeatherData: Equatable {
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.coord.lon == rhs.coord.lon && lhs.coord.lat == rhs.coord.lat
        
    }
}

extension Coord: Equatable {
    static func == (lhs: Coord, rhs: Coord) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
}

extension ForcastData: Equatable {
    static func == (lhs: ForcastData, rhs: ForcastData) -> Bool {
        return lhs.list.description == rhs.list.description
    }
    
    
}
