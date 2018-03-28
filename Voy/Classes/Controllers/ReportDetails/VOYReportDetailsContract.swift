//
//  VOYReportDetailsContract.swift
//  Voy
//
//  Created by Dielson Sales on 27/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYReportDetailsContract: class {
    func setupText(title: String, date: String, description: String, tags: [String])
    func setThemeColor(themeColorHex: String)
    func setMedias(_ medias: [VOYMedia])
    func navigateToPictureScreen(image: UIImage)
    func navigateToVideoScreen(videoURL: URL)
    func navigateToCommentsScreen(report: VOYReport)
    func setCommentButtonEnabled(_ enabled: Bool)
}
