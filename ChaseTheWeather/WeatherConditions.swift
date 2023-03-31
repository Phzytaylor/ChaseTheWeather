//
//  WeatherConditions.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/27/23.
//

import SwiftUI

struct WeatherConditionsView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var rainAngle = 0.0
    @State private var rainIntensity = 500.0
    @State private var lightningMaxBolts = 4.0
    @State private var lightningForkProbability = 20.0
    
    let gradientStops = GradientStops()
    
    var body: some View {
            
        // If I had more time I would take into account the second weather in the array, but the first item is the dominant weather so I have choosen to go with that when determaining which cloud thickness to use.
        switch weatherViewModel.weatherConditions {
            case .clear:
                EmptyView()
                
            case .clouds:
                CloudsView(thickness: .fromWeatherDescription(weatherViewModel.weatherData?.weather.first?.description ?? ""), topTint: gradientStops.cloudTopStops.interpolated(amount: weatherViewModel.timeOfDay), bottomTint: gradientStops.cloudBottomStops.interpolated(amount: weatherViewModel.timeOfDay))
                
            case .rain:
                CloudsView(thickness: .fromWeatherDescription(weatherViewModel.weatherData?.weather.first?.description ?? ""), topTint: gradientStops.cloudTopStops.interpolated(amount: weatherViewModel.timeOfDay), bottomTint: gradientStops.cloudBottomStops.interpolated(amount: weatherViewModel.timeOfDay))
            
            if let stormStrength = weatherViewModel.weatherData?.weather.first {
                // multiply by 100 so we get a value. Didn't want to write two functions that do the same exact thing.
                StormView(type: .rain, direction: .degrees(rainAngle), strength: Int(weatherViewModel.weatherConditions.stormStrength(weather: stormStrength) * 100))
            }
            
                
            case .snow:
                CloudsView(thickness: .fromWeatherDescription(weatherViewModel.weatherData?.weather.first?.description ?? ""), topTint: gradientStops.cloudTopStops.interpolated(amount: weatherViewModel.timeOfDay), bottomTint: gradientStops.cloudBottomStops.interpolated(amount: weatherViewModel.timeOfDay))
                
            if let stormStrength = weatherViewModel.weatherData?.weather.first {
                StormView(type: .snow, direction: .degrees(rainAngle), strength: Int(weatherViewModel.weatherConditions.stormStrength(weather: stormStrength) * 100))
            }
                
            case .thunderstorm:
                CloudsView(thickness: .fromWeatherDescription(weatherViewModel.weatherData?.weather.first?.description ?? ""), topTint: gradientStops.cloudTopStops.interpolated(amount: weatherViewModel.timeOfDay), bottomTint: gradientStops.cloudBottomStops.interpolated(amount: weatherViewModel.timeOfDay))
                
            if let stormStrength = weatherViewModel.weatherData?.weather.first {
                StormView(type: .rain, direction: .degrees(rainAngle), strength: Int(weatherViewModel.weatherConditions.stormStrength(weather: stormStrength) * 100))
            }
                LightningView(maximumBolts: Int(lightningMaxBolts), forkProbability: Int(lightningForkProbability))
                
            case .unknown:
                EmptyView()
            }
        
    }
}

struct WeatherConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherConditionsView().environmentObject(WeatherViewModel(locationHandler: LocationManager(), userDefaults: SendableUserDefaults()))
    }
}
