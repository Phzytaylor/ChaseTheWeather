//
//  Cloud.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/23/23.
//
import SwiftUI

/// A  Class that creates clouds in the background
class Cloud {
    // the position of the cloud on the screen
    var position: CGPoint
    // number of clouds on screen
    let imageNumber: Int
    // how fast the cloud moves
    let speed = Double.random(in: 4...12)
    //scales the image
    let scale: Double
    
    enum Thickness {
        case none, thin, light, regular, thick, ultra
        
        static func fromWeatherDescription(_ description: String) -> Thickness {
            switch description.lowercased() {
            case "clear sky":
                return .none
            case "few clouds":
                return .thin
            case "scattered clouds":
                return .light
            case "broken clouds":
                return .regular
            case "overcast clouds":
                return .thick
            case "shower rain", "light intensity drizzle", "drizzle", "heavy intensity drizzle", "light intensity drizzle rain", "drizzle rain", "heavy intensity drizzle rain", "shower rain and drizzle", "heavy shower rain and drizzle", "shower drizzle":
                return .light
            case "rain", "light rain", "moderate rain", "heavy intensity rain", "very heavy rain", "extreme rain", "freezing rain", "light intensity shower rain", "heavy intensity shower rain", "ragged shower rain":
                return .regular
            case "thunderstorm", "thunderstorm with light rain", "thunderstorm with rain", "thunderstorm with heavy rain", "light thunderstorm", "heavy thunderstorm", "ragged thunderstorm", "thunderstorm with light drizzle", "thunderstorm with drizzle", "thunderstorm with heavy drizzle":
                return .ultra
            case "snow", "light snow", "heavy snow", "sleet", "light shower sleet", "shower sleet", "light rain and snow", "rain and snow", "light shower snow", "shower snow", "heavy shower snow":
                return .thick
            case "mist", "smoke", "haze", "sand, dust whirls", "fog", "sand", "dust", "volcanic ash", "squalls", "tornado":
                return .regular
            default:
                return .none
            }
        }
    }
    init(imageNumber: Int, scale: Double) {
        self.imageNumber = imageNumber
        self.scale = scale
        
        let startX = Double.random(in: -400...400)
        let startY = Double.random(in: -50...200)
        position = CGPoint(x: startX, y: startY)
    }
}
