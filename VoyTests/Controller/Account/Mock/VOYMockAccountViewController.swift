//
//  VOYMockAccountViewController.swift
//  VoyTests
//
//  Created by Pericles Jr on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
@testable import Voy

class VOYMockAccountViewController: VOYAccountContract {
    
    var userTappedLogout: Bool = false
    var didSaveAccount: Bool = false
    var enabledDisabledLoading: Int = 0
    
    func setupLoading(showLoading: Bool) {
        enabledDisabledLoading += 1
        if enabledDisabledLoading == 1 {
            save()
        }
    }
    
    func save() {
        didSaveAccount = true
    }
    
    func btLogoutTapped() {
        userTappedLogout = true
    }
}
