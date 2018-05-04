//
//  VOYServicesProvider.swift
//  Voy
//
//  Created by Dielson Sales on 03/05/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYServicesProvider {

    static let shared = VOYServicesProvider()

    let locationManager: VOYLocationManager = VOYDefaultLocationManager()
}
