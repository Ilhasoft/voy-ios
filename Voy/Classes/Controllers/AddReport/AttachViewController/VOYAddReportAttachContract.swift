//
//  VOYAddReportAttachContract.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYAddReportAttachContract: class {
    func loadFromReport(mediaList: [VOYMedia], cameraDataList: [VOYCameraData])
    func navigateToNextScreen(report: VOYReport)
    func showAlert(text: String)
    func stopAnimating()
    func showGpsPermissionError()
}
