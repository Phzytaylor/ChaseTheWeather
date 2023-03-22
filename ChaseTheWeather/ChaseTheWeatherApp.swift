//
//  ChaseTheWeatherApp.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/22/23.
//

import SwiftUI

@main
struct ChaseTheWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
