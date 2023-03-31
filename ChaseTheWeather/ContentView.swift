//
//  ContentView.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/22/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var weatherViewModel = WeatherViewModel(locationHandler: LocationManager(), userDefaults: SendableUserDefaults())
    @State var searchString: String = ""
    @State var shouldMove = false
    @State var showingSearch = false
    @State private var stormType = Storm.Contents.none
    @State private var rainIntensity = 500.0
    @State private var rainAngle = 0.0
    @State private var lightningMaxBolts = 4.0
    @State private var lightningForkProbability = 20.0
    let gradientStops = GradientStops()
    
    var starOpacity: Double {
        let color = gradientStops.starStops.interpolated(amount: weatherViewModel.timeOfDay)
        return color.getComponents().alpha
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                SunView(progress: weatherViewModel.timeOfDay)
                StarsView().opacity(starOpacity)
                WeatherConditionsView().environmentObject(weatherViewModel)
                    
                if let weatherData = weatherViewModel.weatherData, let forecastData = weatherViewModel.forecastData, let condition = weatherViewModel.weatherConditions, let weather = weatherData.weather.first {
                        
                    let residueViewStrength = condition.stormStrength(weather: weather)
                        ScrollView {
                            VStack {
                                WeatherView(weatherData: weatherData)
                                if condition == .snow {
                                    ResidueView(type: .snow, strength: residueViewStrength)
                                        .frame(height: 62)
                                        .offset(y: 50)
                                        .zIndex(1)
                                } else if condition == .rain {
                                    ResidueView(type: .rain , strength: residueViewStrength)
                                        .frame(height: 62)
                                        .offset(y: 50)
                                        .zIndex(1)
                                }
                                
                                ForecastView(forecastData: forecastData).frame(minHeight: 200)
                            }
                            
                            Button(action: {
                                showingSearch = true
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }

                        }
                        
                    } else {
                        VStack {
                            WeatherView(weatherData: nil)
                        }
                    }
                
            }.preferredColorScheme(.dark).frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(colors: [
                        gradientStops.backgroundTopStops.interpolated(amount: weatherViewModel.timeOfDay),
                        gradientStops.backgroundBottomStops.interpolated(amount: weatherViewModel.timeOfDay)
                    ], startPoint: .top, endPoint: .bottom)
                ).navigationDestination(isPresented: $showingSearch) {
                    SearchView(searchString: $searchString, showingSearch: $showingSearch).environmentObject(weatherViewModel)
                }
        } .alert(item: $weatherViewModel.locationError) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")) {
                weatherViewModel.locationError = nil
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MyViews: Hashable {
    let searchView: String
}
