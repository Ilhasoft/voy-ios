//
//  VOYDefaultLocationManager.swift
//  Voy
//
//  Created by Dielson Sales on 24/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import CoreLocation

class VOYDefaultLocationManager: NSObject, CLLocationManagerDelegate, VOYLocationManager {

    var locationManager: CLLocationManager?

    required init(delegate: VOYLocationManagerDelegate) {
        super.init()
        self.delegate = delegate
    }

    weak var delegate: VOYLocationManagerDelegate?

    func locationPermissionIsGranted() -> Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
    }

    func getCurrentLocation() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }

        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager?.startUpdatingLocation()
            } else if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager?.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .denied {
                self.delegate?.userDidntGivePermission()
            }
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
        if let userLocation = locations.first {
            VOYLocationData.latitude = Float(userLocation.coordinate.latitude)
            VOYLocationData.longitude = Float(userLocation.coordinate.longitude)
            self.delegate?.didGetUserLocation(
                latitude: VOYLocationData.latitude,
                longitude: VOYLocationData.longitude,
                error: nil
            )
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.didGetUserLocation(latitude: 0, longitude: 0, error: error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.delegate?.userDidntGivePermission()
        case .authorizedWhenInUse :
            if VOYLocationData.latitude == 0 {
                self.locationManager?.startUpdatingLocation()
            }
        default:
            break
        }
    }
}
