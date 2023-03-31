//
//  Meteor.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

class Meteor {
    let id = UUID()
    var x: Double
    var y: Double
    var length = 0.0
    var isMovingRight: Bool
    var speed = 1200.0

    init(x: Double, y: Double, isMovingRight: Bool) {
        self.x = x
        self.y = y
        self.isMovingRight = isMovingRight
    }
}

extension Meteor: Hashable {
    
    static func ==(lhs: Meteor, rhs: Meteor) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
