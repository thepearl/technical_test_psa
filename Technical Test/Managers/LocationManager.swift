//
//  LocationManager.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 15/7/2022.
//

import Foundation
import CoreLocation


class LocationManager: NSObject {
    
    // - private
    private let locationManager = CLLocationManager()
    
    // - API
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
}


// MARK: - Core Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            print("locationManager: notDetermined")
        case .authorizedWhenInUse, .authorizedAlways:
            print("locationManager: authorized ")
        case .restricted:
            print("locationManager: restricted")
        case .denied:
            self.locationManager.requestWhenInUseAuthorization()
            print("locationManager: denied")
        @unknown default:
            print("locationManager: default unknown status")
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        self.authorizationStatus = status
    }
}

// MARK: - Get Placemark
extension LocationManager {
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        guard self.authorizationStatus.atLeastOnce else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}

extension CLAuthorizationStatus {
    var atLeastOnce: Bool {
        return self == .authorizedAlways || self == .authorizedWhenInUse 
    }
}
