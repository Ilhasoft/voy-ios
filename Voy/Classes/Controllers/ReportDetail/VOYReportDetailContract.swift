//
//  VOYReportDetailContract.swift
//  Voy
//
//  Created by Dielson Sales on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYReportDetailContract: class {
    func navigateToCommentsScreen(report: VOYReport)
    func shareText(_ string: String)
    func showPictureScreen(image: UIImage)
    func showVideoScreen(videoURL: URL)
    func showActionSheet()
    func navigateToEditReportScreen(report: VOYReport)
    func setCommentButtonEnabled(_ enabled: Bool)
}
