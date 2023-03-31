//
//  Array-GradientStop.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/23/23.
//

import SwiftUI

extension Array where Element == Gradient.Stop {
    /// Calculates the color between a range of at least two colors `amount:` is total interpolation
    ///
    /// This method calculates the interpolated color based on the `amount`, which is a value between
    /// 0 and 1. The `amount` determines the position of the interpolated color between the colors
    /// of the gradient stops.
    func interpolated(amount: Double) -> Color {
        // Ensure the gradient stop array is not empty
        guard let initialStop = self.first else {
            fatalError("Attempt to read color from empty stop array.")
        }

        var firstStop = initialStop
        var secondStop = initialStop

        // Find the two stops that surround the interpolation amount
        for stop in self {
            if stop.location < amount {
                firstStop = stop
            } else {
                secondStop = stop
                break
            }
        }
        
        // Calculate the relative difference between the two stops
        let totalDifference = secondStop.location - firstStop.location

        // Interpolate the color based on the relative difference
        if totalDifference > 0 {
            let relativeDifference = (amount - firstStop.location) / totalDifference
            return firstStop.color.interpolated(to: secondStop.color, amount: relativeDifference)
        } else {
            return firstStop.color.interpolated(to: secondStop.color, amount: 0)
        }
    }
}

