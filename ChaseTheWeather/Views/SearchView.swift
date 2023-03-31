import SwiftUI

struct SearchView: View {
    @Binding var searchString: String
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Binding var showingSearch: Bool
    @State private var searchWorkItem: DispatchWorkItem?


    
    func runSearch() {
            Task {
                await weatherViewModel.searchWeather(byCityName:searchString)
                await weatherViewModel.searchForecast(byCityName: searchString)
                showingSearch.toggle()
                weatherViewModel.saveCity(name: searchString)
            }
        }

    var body: some View {
        NavigationView {
            VStack {
                // I made my own List type so it we had a naming conflict
                SwiftUI.List {
                    ForEach(weatherViewModel.getCities()) { city in
                        Text(city.name).padding().onTapGesture {
                            searchString = city.name
                            runSearch()
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Search", displayMode: .inline)
            .searchable(text: $searchString, prompt: "Enter a city")
            .onSubmit(of: .search, runSearch)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchString: .constant(""), showingSearch: .constant(true))
            .environmentObject(WeatherViewModel(locationHandler: LocationManager(), userDefaults: SendableUserDefaults()))
    }
}
