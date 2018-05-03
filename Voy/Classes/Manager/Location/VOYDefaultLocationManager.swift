//
//  VOYDefaultLocationManager.swift
//  Voy
//
//  Created by Dielson Sales on 24/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import CoreLocation

class VOYDefaultLocationManager: NSObject, CLLocationManagerDelegate, VOYLocationManager {
    var locationManager: CLLocationManager
    var isUpdatingLocation = false

    weak var delegate: VOYLocationManagerDelegate?

    override required init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
    }

    func locationPermissionIsGranted() -> Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
    }

    func getCurrentLocation() {
        isUpdatingLocation = true
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .denied {
                self.delegate?.userDidntGivePermission()
            }
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isUpdatingLocation else { return }
        isUpdatingLocation = false
        self.locationManager.stopUpdatingLocation()
        if let userLocation = locations.first {
            self.delegate?.didGetUserLocation(
                latitude: Float(userLocation.coordinate.latitude),
                longitude: Float(userLocation.coordinate.longitude),
                error: nil
            )
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard isUpdatingLocation else { return }
        isUpdatingLocation = false
        self.locationManager.stopUpdatingLocation()
        self.delegate?.didGetUserLocation(latitude: 0, longitude: 0, error: error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.delegate?.userDidntGivePermission()
        case .authorizedWhenInUse :
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
