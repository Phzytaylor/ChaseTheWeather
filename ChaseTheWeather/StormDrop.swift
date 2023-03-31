//
//  StormDrop.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

/// `StormDrop` is a class representing a single drop (raindrop or snowflake) in a storm.
class StormDrop {
    // Properties related to the drop's position and scale on the screen
    var x: Double
    var y: Double
    var xScale: Double
    var yScale: Double
    
    // Properties related to the drop's movement and appearance
    var speed: Double
    var opacity: Double
    var direction: Angle
    var rotation: Angle
    var rotationSpeed: Angle
    
    /// Initializes a `StormDrop` object with the given type (rain or snow) and direction (angle).
    /// - Parameters:
    ///   - type: A `Storm.Contents` value representing the type of drop (raindrop or snowflake).
    ///   - direction: An `Angle` value representing the direction in which the drop will move.
    init(type: Storm.Contents, direction: Angle) {
        // Adjusts the direction for snow type
        if type == .snow {
            self.direction = direction + .degrees(.random(in: -15...15))
        } else {
            self.direction = direction
        }

        // Initializes the position of the drop within the given range
        x = Double.random(in: -0.2...1.2)
        y = Double.random(in: -0.2...1.2)

        // Sets properties based on the type of storm content
        switch type {
        case .snow:
            // Snowflakes have a random size and are slower than raindrops
            xScale = Double.random(in: 0.125...1)
            yScale = xScale * Double.random(in: 0.5...1)
            speed = Double.random(in: 0.2...0.6)
            opacity = Double.random(in: 0.2...1)
            // Snowflakes have random rotation and rotation speed
            rotation = Angle.degrees(Double.random(in: 0...360))
            rotationSpeed = Angle.degrees(Double.random(in: -360...360))
        default:
            // Raindrops have a random size and are faster than snowflakes
            xScale = Double.random(in: 0.4...1)
            yScale = xScale
            speed = Double.random(in: 1...2)
            // Raindrops have a random opacity within the specified range
            opacity = Double.random(in: 0.05...0.3)
            // Raindrops don't have rotation or rotation speed
            rotation = Angle.zero
            rotationSpeed = Angle.zero
        }
    }
}

