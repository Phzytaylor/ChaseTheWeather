//
//  MockLocationHandler.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/30/23.
//

import Foundation
import CoreLocation

class MockLocationHandler: LocationHandler {
    func getAuthStatus() -> CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
    
    var onLocationUpdate: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?

    func requestPermission() {
        // Do nothing for testing
    }

    func simulateLocationUpdate(location: CLLocation) {
        onLocationUpdate?(location)
    }

    func simulateLocationError(error: Error) {
        onLocationError?(error)
    }
}
