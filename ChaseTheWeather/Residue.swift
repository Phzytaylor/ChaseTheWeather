//
//  Residue.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/25/23.
//

import SwiftUI

class Residue {
    // We use a set here because we don't plan to recyle drops, we add and remove as needed
    // this helps to make sure that not all these drop appear at the same time
    var drops = Set<ResidueDrop>()
    var lastUpdate = Date.now
    var nextCreationTime = Date.now
    
    let image = Image("snow")
    let type: Storm.Contents
    
    let creationAmount: Int
    let lifetime: ClosedRange<Double>
    let creationDelay: ClosedRange<Double>?
    
    init(type: Storm.Contents, strength: Double) {
        self.type = type
        
        switch type {
        case .snow:
            // the snow will pile up so we only want one particle
            // the life time is long because snow clumps :)
            creationAmount = 1
            lifetime = 1.0...2.0
        default:
            // the water splits into several droplets and they don't live long :(
            creationAmount = 3
            lifetime = 0.9...1.1
        }
        
        if type == .none || strength == 0 {
            creationDelay = nil
        } else {
            switch strength {
            case 1...200:
                creationDelay = 0...0.25
            case 201...400:
                creationDelay = 0...0.1
            case 401...800:
                creationDelay = 0...0.05
            default:
                creationDelay = 0...0.02
            }
        }
    }
    
    func update(date: Date, size: CGSize) {
        //no need to run any of the updates if there is no creation delay
        guard let creationDelay = creationDelay else { return }

        let currentTime = date.timeIntervalSince1970
        let delta = currentTime - lastUpdate.timeIntervalSince1970
        let divisor = size.height / size.width

        for drop in drops {
            drop.x += drop.xMovement * drop.speed * delta * divisor
            drop.y += drop.yMovement * drop.speed * delta
            drop.yMovement += delta * 2

            // if drop has gone passed the 'ground' make it stop
            if drop.y > 0.5 {
                // stop the drop as long as it's not at the edges
                if drop.x > 0.075 && drop.x < 0.925 {
                    drop.y = 0.5
                    drop.yMovement = 0
                }
            }

            if drop.destructionTime < currentTime {
                drops.remove(drop)
            }
        }
        
        if nextCreationTime.timeIntervalSince1970 < currentTime {
            let dropX = Double.random(in: 0.075...0.925)

            for _ in 0..<creationAmount {
                drops.insert(ResidueDrop(type: type, xPosition: dropX, destructionTime: currentTime + .random(in: lifetime)))
            }

            nextCreationTime = Date.now + Double.random(in: creationDelay)
            lastUpdate = date
            
        }
    }
}
