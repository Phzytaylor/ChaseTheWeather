//
//  WeatherView.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/22/23.
//
import SwiftUI

struct WeatherView: View {
    let weatherData: WeatherData?

    var body: some View {
        VStack(spacing: 10) {
            Text(weatherData?.name ?? "--")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, 20)

            if let iconCode = weatherData?.weather.first?.icon {
                let iconUrl = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
                // Async image doesn't have caching so we made our own :)
                CachedImage(url: iconUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                        .resizable()
                        .frame(width: 80, height: 80)
                    case .failure:
                        Image(systemName: "xmark")
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "xmark")
            }

            Text("\(weatherData?.main.temp ?? 0, specifier: "%.0f")º")
                .font(.system(size: 80, weight: .thin))
                .padding(.top, 5)

            Text(weatherData?.weather.first?.description.capitalized ?? "--")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 5)

            Text("H: \(weatherData?.main.tempMax ?? 0, specifier: "%.0f")º L: \(weatherData?.main.tempMin ?? 0, specifier: "%.0f")º")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 3)
        }
    }
}

