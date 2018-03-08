//
//  VOYMockLoginViewController.swift
//  Voy
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
@testable import Voy

open class VOYMockLoginViewController: VOYLoginContract {
    var redirectedUser: Bool
    var presentedAlert: Bool
    
    init(redirectedUser: Bool, presentedAlert: Bool) {
        self.redirectedUser = redirectedUser
        self.presentedAlert = presentedAlert
    }
    
    public func redirectController() {
        redirectedUser = true
    }
    
    public func presentErrorAlert() {
        presentedAlert = true
    }
}
