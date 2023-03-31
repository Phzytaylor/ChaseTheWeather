//
//  ForecastView.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/26/23.
//

import SwiftUI

struct ForecastView: View {
    let forecastData: ForcastData

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(forecastData.list) { forecast in
                    ForecastRow(forecast: forecast)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(Color.black.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
}


