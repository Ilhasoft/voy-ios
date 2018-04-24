//
//  VOYLocationManager.swift
//  Voy
//
//  Created by Daniel Amaral on 16/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import CoreLocation

protocol VOYLocationManagerDelegate: class {
    func didGetUserLocation(latitude: Float, longitude: Float, error: Error?)
    func userDidntGivePermission()
}

protocol VOYLocationManager: class {
    init(delegate: VOYLocationManagerDelegate)
    func locationPermissionIsGranted() -> Bool
    func getCurrentLocation()
}

class VOYLocationData {
    static var latitude: Float = 0
    static var longitude: Float = 0
}
