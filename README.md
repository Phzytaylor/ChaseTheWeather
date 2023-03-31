# ChaseTheWeather

A simple weather app that fetches current weather and 5-day forecast data for a given location. The app is built with Swift and SwiftUI, and uses CoreLocation for location services.
Along with https://openweathermap.org

## Features

- Fetch current weather data for a given city or the user's location
- Display 5-day weather forecast with 3-hour intervals
- Save and manage a list of favorite cities
- Automatically fetch weather data for the last searched city upon launching the app
- Handle various network errors gracefully

## Installation

To run the app on your machine, follow these steps:

1. Clone the repository:

```sh
git clone https://github.com/yourusername/ChaseTheWeather.git
cd weather-app
open WeatherApp.xcodeproj
```
Add your API key to the WeatherAPIClient.swift file
```swift
private let apiKey = "YOUR_API_KEY"
```
## Dependencies

Swift 5.5
SwiftUI
CoreLocation

## Preview:

![image](https://user-images.githubusercontent.com/10688736/229030442-23485f16-ce6d-4297-92f2-2cead851254a.png)
![image](https://user-images.githubusercontent.com/10688736/229030512-c66f9595-3df4-493e-b696-1cf87b77ef7c.png)

![image](https://user-images.githubusercontent.com/10688736/229030769-df0dc5f8-89f9-450d-9ea9-955d4e0df712.png)

