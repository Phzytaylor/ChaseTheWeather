//
//  CloudsView.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/23/23.
//

import SwiftUI

// A view that renders clouds on the screen.
struct CloudsView: View {
    var cloudGroup: CloudGroup
    let topTint: Color
    let bottomTint: Color
    
    var body: some View {
        // Use a TimelineView to update the clouds' positions over time.
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                // Update the cloud positions based on the current time.
                cloudGroup.update(date: timeline.date)
                context.opacity = cloudGroup.opacity
                
                // Resolve cloud images and apply linear gradient shading.
                let resolvedImages = (0..<8).map { i -> GraphicsContext.ResolvedImage in
                    let sourceImage = Image("cloud\(i)")
                    var resolved = context.resolve(sourceImage)
                    
                    resolved.shading = .linearGradient(
                        Gradient(colors: [topTint, bottomTint]),
                        startPoint: CGPoint(x: 0, y: 0),
                        endPoint: CGPoint(x: 0, y: resolved.size.height)
                    )
                    
                    return resolved
                }
                
                // Draw the clouds on the canvas.
                for cloud in cloudGroup.clouds {
                    context.translateBy(x: cloud.position.x, y: cloud.position.y)
                    context.scaleBy(x: cloud.scale, y: cloud.scale)

                    context.draw(resolvedImages[cloud.imageNumber], at: .zero, anchor: .topLeading)

                    context.transform = .identity
                }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // Initializes a new CloudsView with the given parameters.
    //
    // - Parameters:
    //   - thickness: The thickness of the cloud group.
    //   - topTint: The color tint for the top of the clouds.
    //   - bottomTint: The color tint for the bottom of the clouds.
    init(thickness: Cloud.Thickness, topTint: Color, bottomTint: Color) {
        cloudGroup = CloudGroup(thickness: thickness)
        self.topTint = topTint
        self.bottomTint = bottomTint
    }
}


struct CloudsView_Previews: PreviewProvider {
    static var previews: some View {
        CloudsView(thickness: .regular, topTint: .white, bottomTint: .white)
            .background(.blue)
    }
}
