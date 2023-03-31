//
//  LightningView.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

struct LightningView: View {
    var lightning: Lightning
    
    var body: some View {
        // same as other views... over time lighting will strike
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                lightning.update(date: timeline.date, in: size)
                
                let fullScreen = Path(CGRect(origin: .zero, size: size))
                context.fill(fullScreen, with: .color(.white.opacity(lightning.flashOpacity)))
                
                for _ in 0..<2 {
                    for bolt in lightning.bolts {
                        var path = Path()
                        path.addLines(bolt.points)
                        context.stroke(path, with: .color(.white), lineWidth: bolt.width)
                    }
                    
                    context.addFilter(.blur(radius: 5))
                }            }
        }
        .ignoresSafeArea()
    }
    
    func startRandomStrikes() {
        let randomTimeInterval = Double.random(in: 1...3)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomTimeInterval) {
            lightning.strike()
            startRandomStrikes()
        }
    }
    
    init(maximumBolts: Int = 4, forkProbability: Int = 20) {
        lightning = Lightning(maximumBolts: maximumBolts, forkProbability: forkProbability)
        startRandomStrikes()
    }
}

struct LightningView_Previews: PreviewProvider {
    static var previews: some View {
        LightningView()
    }
}
