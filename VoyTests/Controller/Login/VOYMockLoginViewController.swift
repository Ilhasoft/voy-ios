//
//  VOYMockLoginViewController.swift
//  Voy
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

open class VOYMockLoginViewController: VOYLoginContract {
    var redirectedUser = false
    var presentedAlert = false

    public func startProgressIndicator() {
        // Does nothing
    }

    public func stopProgressIndicator() {
        // Does nothing
    }

    public func redirectController() {
        redirectedUser = true
    }

    public func presentErrorAlert() {
        presentedAlert = true
    }
}
