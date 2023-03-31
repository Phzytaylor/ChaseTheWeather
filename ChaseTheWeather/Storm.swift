//
//  Storm.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

class Storm {
    // Defines the type of weather content in the storm
    enum Contents: CaseIterable {
        case none, rain, snow
    }
    
    var drops = [StormDrop]()
    var lastUpdate = Date.now
    var image: Image
    
    // Initializes a Storm object with the given type, direction, and strength
    init(type: Contents, direction: Angle, strength: Int) {
        // Sets the image based on the type of storm content
        switch type {
        case .snow:
            image = Image("snow")
        default:
            image = Image("rain")
        }

        // Creates storm drops according to the specified strength
        for _ in 0..<strength {
            drops.append(StormDrop(type: type, direction: direction + .degrees(90)))
        }
    }
    
    // Updates the storm drops' positions and rotations based on the time elapsed
    func update(date: Date, size: CGSize) {
        let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
        let divisor = size.height / size.width

        // Updates the position and rotation of each drop in the storm
        for drop in drops {
            let radians = drop.direction.radians
            drop.x += cos(radians) * drop.speed * delta * divisor
            drop.y += sin(radians) * drop.speed * delta

            // Re-positions the drop if it goes off the screen
            if drop.x < -0.2 {
                drop.x += 1.4
            }

            if drop.y > 1.2 {
                drop.x = Double.random(in: -0.2...1.2)
                drop.y -= 1.4
            }

            drop.rotation += drop.rotationSpeed * delta
        }

        lastUpdate = date
    }
}

