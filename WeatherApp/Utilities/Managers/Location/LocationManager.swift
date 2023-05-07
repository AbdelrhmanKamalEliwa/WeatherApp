//
//  LocationManager.swift
//
//  Created by Abdelrhman Eliwa.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager: CLLocationManager
    private var currentLocationCoordinates: CLLocationCoordinate2D?
    
    private override init() {
        locationManager = CLLocationManager()
        
        super.init()
    }
}

// MARK: - PRIVATE METHODS
//
private extension LocationManager {
    func setLocation() {
        currentLocationCoordinates = locationManager.location?.coordinate
    }
}

// MARK: - LocationManagerContract
//
extension LocationManager: LocationManagerContract {
    func requestAuthorization() -> Result<Void, BaseError> {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return .failure(.init(code: -1, message: "Need authorization"))
            
        case .authorizedWhenInUse, .authorizedAlways:
            setLocation()
            return .success(())
            
        default:
            return .failure(.init(code: -1, message: "Need authorization"))
        }
    }
    
    func getCurrentLocation() -> Result<LocationCoordinate, BaseError> {
        guard
            let latitude = currentLocationCoordinates?.latitude,
            let longitude = currentLocationCoordinates?.longitude
        else {
            return .failure(ErrorResolver.shared.getError(for: .unexpected))
        }
        
        return .success(.init(latitude: latitude, longitude: longitude))
    }
}
