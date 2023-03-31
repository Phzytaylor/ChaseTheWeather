//
//  ResidueDrop.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

/// `ResidueDrop` is a class that represents a residue drop, which is a particle left behind
/// on the screen by a storm event. It handles the properties of the residue drop, such as its
/// position, size, and appearance.
class ResidueDrop {
    var id = UUID()
    var destructionTime: Double
    var x: Double
    var y = 0.5
    var scale: Double
    var speed: Double
    var opacity: Double
    var xMovement: Double
    var yMovement: Double

    /// Initialize a new `ResidueDrop` with the given parameters.
    ///
    /// - Parameters:
    ///   - type: The type of storm content (`Storm.Contents`), e.g., rain or snow.
    ///   - xPosition: The initial x position of the residue drop on the canvas.
    ///   - destructionTime: The time at which the residue drop will be destroyed.
    init(type: Storm.Contents, xPosition: Double, destructionTime: Double) {
        self.x = xPosition
        self.destructionTime = destructionTime

        // Set the properties of the residue drop based on the type of storm content
        switch type {
        case .snow:
            scale = Double.random(in: 0.125...0.75)
            opacity = Double.random(in: 0.2...0.7)
            speed = 0
            xMovement = 0
            yMovement = 0
        default:
            scale = Double.random(in: 0.4...0.5)
            opacity = Double.random(in: 0...0.3)
            speed = 2
            let direction = Angle.degrees(.random(in: 225...315)).radians
            xMovement = cos(direction)
            yMovement = sin(direction) / 1.5
        }
    }
}

extension ResidueDrop : Hashable {
    static func ==(lhs: ResidueDrop, rhs: ResidueDrop) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
