//
//  CloudGroup.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/23/23.
//

import SwiftUI

// A class representing a group of clouds in the sky.
class CloudGroup {
    var clouds = [Cloud]()
    var lastUpdate = Date.now
    let opacity: Double
    
    // Initializes a new CloudGroup based on the given thickness.
    //
    // - Parameters:
    //   - thickness: The thickness of the cloud group.
    init(thickness: Cloud.Thickness) {
        let cloudsToCreate: Int
        let cloudScale: ClosedRange<Double>

        // Set parameters for the cloud group based on the thickness.
        switch thickness {
        case .none:
            cloudsToCreate = 0
            opacity = 1
            cloudScale = 1...1
        case .thin:
            cloudsToCreate = 10
            opacity = 0.6
            cloudScale = 0.2...0.4
        case .light:
            cloudsToCreate = 10
            opacity = 0.7
            cloudScale = 0.4...0.6
        case .regular:
            cloudsToCreate = 15
            opacity = 0.8
            cloudScale = 0.7...0.9
        case .thick:
            cloudsToCreate = 25
            opacity = 0.9
            cloudScale = 1.0...1.3
        case .ultra:
            cloudsToCreate = 40
            opacity = 1
            cloudScale = 1.2...1.6
        }

        // Create the clouds based on the set parameters.
        for i in 0..<cloudsToCreate {
            let scale = Double.random(in: cloudScale)
            let imageNumber = i % 8
            let cloud = Cloud(imageNumber: imageNumber, scale: scale)
            clouds.append(cloud)
        }
    }
    
    // Update the cloud positions based on the given date.
    //
    // - Parameters:
    //   - date: The current date.
    func update(date: Date) {
        let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970

        // Update the position of each cloud.
        for cloud in clouds {
            cloud.position.x -= delta * cloud.speed
            
            let offScreenDistance = max(400, 400 * cloud.scale)

            // If the cloud has moved off the screen, reset its position.
            if cloud.position.x < -offScreenDistance {
                cloud.position.x = offScreenDistance
            }
        }

        // Update the last update time.
        lastUpdate = date
    }
}
