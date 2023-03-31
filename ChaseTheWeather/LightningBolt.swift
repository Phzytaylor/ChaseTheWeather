//
//  LightningBolt.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

class LightningBolt {
    var points = [CGPoint]()
    var width: Double
    var angle: Double

    init(start: CGPoint, width: Double, angle: Double) {
        points.append(start)
        self.width = width
        self.angle = angle
    }
}
