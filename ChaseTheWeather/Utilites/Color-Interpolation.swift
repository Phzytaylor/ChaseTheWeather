//
//  Color-Interpolation.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/24/23.
//

import Foundation
import SwiftUI

extension Color {
    /// Retrieves the red, green, blue, and alpha components of a Color
    ///
    /// This method returns the components of the Color as a tuple containing the red, green,
    /// blue, and alpha values as `Double` values.
    func getComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let uiColor = UIColor(self)
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    /// Interpolates the color to another color based on the specified `amount`
    ///
    /// This method calculates the interpolated color between `self` and `other` based on the
    /// provided `amount`. The `amount` parameter is a value between 0 and 1 that determines
    /// the position of the interpolated color between the two colors.
    func interpolated(to other: Color, amount: Double) -> Color {
        let componentsFrom = self.getComponents()
        let componentsTo = other.getComponents()

        let newRed = (1.0 - amount) * componentsFrom.red + (amount * componentsTo.red)
        let newGreen = (1.0 - amount) * componentsFrom.green + (amount * componentsTo.green)
        let newBlue = (1.0 - amount) * componentsFrom.blue + (amount * componentsTo.blue)
        let newOpacity = (1.0 - amount) * componentsFrom.alpha + (amount * componentsTo.alpha)

        return Color(.displayP3, red: newRed, green: newGreen, blue: newBlue, opacity: newOpacity)
    }
}

