//
//  StormView.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

/// `StormView` is a SwiftUI `View` that represents a storm, rendering raindrops or snowflakes on the screen.
struct StormView: View {
    // The `Storm` object that contains the storm data and logic
    let storm: Storm

    // The body of the view
    var body: some View {
        // TimelineView is used to animate the storm over time
        TimelineView(.animation) { timeline in
            // Canvas is used to draw the storm's contents
            Canvas { context, size in
                // Update the storm based on the current timeline and canvas size
                storm.update(date: timeline.date, size: size)

                // Iterate through each drop in the storm and draw it on the canvas
                for drop in storm.drops {
                    // Make a copy of the graphics context to apply transformations
                    var contextCopy = context

                    // Calculate the x and y position of the drop on the canvas
                    let xPos = drop.x * size.width
                    let yPos = drop.y * size.height

                    // Set the opacity of the drop
                    contextCopy.opacity = drop.opacity
                    // Translate the context to the drop's position
                    contextCopy.translateBy(x: xPos, y: yPos)
                    // Rotate the context by the drop's direction and rotation
                    contextCopy.rotate(by: drop.direction + drop.rotation)
                    // Scale the context by the drop's x and y scale
                    contextCopy.scaleBy(x: drop.xScale, y: drop.yScale)
                    // Draw the drop's image at the transformed context's origin
                    contextCopy.draw(storm.image, at: .zero)
                }
            }
        }
        .ignoresSafeArea()
    }

    init(type: Storm.Contents, direction: Angle, strength: Int) {
        storm = Storm(type: type, direction: direction, strength: strength)
    }
}

struct StormView_Previews: PreviewProvider {
    static var previews: some View {
        StormView(type: .rain, direction: .zero, strength: 200)
    }
}
