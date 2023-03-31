//
//  ForecastRow.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/26/23.
//
import SwiftUI

struct ForecastRow: View {
    let forecast: List
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(Date(timeIntervalSince1970: forecast.dt), style: .time)
                .font(.system(size: 16, weight: .bold))
            
            if let iconCode = forecast.weather.first?.icon {
                let iconUrl = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
                CachedImage(url: iconUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                        .resizable()
                        .frame(width: 60, height: 60)
                    case .failure:
                        Image(systemName: "xmark")
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text("\(forecast.main.temp, specifier: "%.0f")º")
                .font(.system(size: 20, weight: .bold))
        }
    }
    
}
