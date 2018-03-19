//
//  VOYAddReportAttachContract.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYAddReportAttachContract: class {
    func navigateToNextScreen()
    func showAlert(alert: VOYAlertViewController)
    func stopAnimating()
    func showGpsPermissionError()
    func showOutsideThemeBoundsError()
}
