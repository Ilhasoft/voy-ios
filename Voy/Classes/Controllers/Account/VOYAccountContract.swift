//
//  VOYAccountContract.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYAccountContract: AnyObject {
    func update(with viewModel: VOYAccountViewModel)
    func showLogoutConfirmation(message: String)
    func showProgress()
    func hideProgress()
    func navigateToLoginScreen()
}
