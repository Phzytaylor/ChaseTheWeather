//
//  LocationManager.swift
//  ChaseTheWeather
//
//  Created by Taylor Simpson on 3/26/23.
//

import Foundation
import CoreLocation

protocol LocationHandler {
    var onLocationUpdate: ((CLLocation) -> Void)? { get set }
    var onLocationError: ((Error) -> Void)? {get set}
    func requestPermission()
    func getAuthStatus() -> CLAuthorizationStatus
}


class LocationManager: NSObject, CLLocationManagerDelegate, LocationHandler {
    private let locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            onLocationUpdate?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        onLocationError?(error)
    }
    
    func getAuthStatus() -> CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
}


struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}

