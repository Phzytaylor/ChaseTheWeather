//
//  Color-Custom.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/23/23.
//
import SwiftUI

extension Color {
    // Midnight background gradient colors
    static let midnightStart = Color(hue: 0.66, saturation: 0.8, brightness: 0.1)
    static let midnightEnd = Color(hue: 0.62, saturation: 0.5, brightness: 0.33)
    
    // Sunrise background gradient colors
    static let sunriseStart = Color(hue: 0.62, saturation: 0.6, brightness: 0.42)
    static let sunriseEnd = Color(hue: 0.95, saturation: 0.35, brightness: 0.66)
    
    // Day background gradient colors
    static let sunnyDayStart = Color(hue: 0.6, saturation: 0.6, brightness: 0.6)
    static let sunnyDayEnd = Color(hue: 0.6, saturation: 0.4, brightness: 0.85)
    
    // Sunset background gradient colors
    static let sunsetStart = Color.sunriseStart
    static let sunsetEnd = Color(hue: 0.05, saturation: 0.34, brightness: 0.65)
    
    // Midnight cloud gradient colors
    static let darkCloudStart = Color(hue: 0.65, saturation: 0.3, brightness: 0.3)
    static let darkCloudEnd = Color(hue: 0.65, saturation: 0.3, brightness: 0.7)
    
    // Day cloud gradient colors
    static let lightCloudStart = Color.white
    static let lightCloudEnd = Color(white: 0.75)
    
    // Sunrise cloud gradient colors
    static let sunriseCloudStart = Color.lightCloudStart
    static let sunriseCloudEnd = Color.sunriseEnd
    
    // Sunset cloud gradient colors
    static let sunsetCloudStart = Color.lightCloudStart
    static let sunsetCloudEnd = Color.sunsetEnd
}

