//
//  VOYMockReportDetailViewController.swift
//  VoyTests
//
//  Created by Dielson Sales on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYMockReportDetailViewController: VOYReportDetailsContract {
    var viewModel: VOYReportDetailsViewModel?
    var hasNavigatedToCommentsScreen = false
    var hasSharedText = false
    var hasShownPicture = false
    var hasShownVideo = false
    var hasShownActionSheet = false
    var hasNavigatedToEditReportScreen = false
    var commentButtonIsEnabled = false
    var hasShownIssueAlert = false
    var hasShownPendingMediasAlert = false
    var hasOpenedURL = false

    func update(with viewModel: VOYReportDetailsViewModel) {
        self.viewModel = viewModel
    }

    func navigateToPictureScreen(image: UIImage) {
        hasShownPicture = true
    }

    func navigateToVideoScreen(videoURL: URL) {
        hasShownVideo = true
    }

    func navigateToCommentsScreen(report: VOYReport) {
        hasNavigatedToCommentsScreen = true
    }

    func setCommentButtonEnabled(_ enabled: Bool) {
        commentButtonIsEnabled = enabled
    }

    func setupNavigationButtons(avatarURL: URL, lastNotification: String?, showOptions: Bool, showShare: Bool) {}

    func navigateToEditReport(report: VOYReport) {
        hasNavigatedToEditReportScreen = true
    }

    func shareText(_ string: String) {
        hasSharedText = true
    }

    func showOptions() {
        hasShownActionSheet = true
    }

    func showIssueAlert(lastNotification: String) {
        hasShownIssueAlert = true
    }

    func showPendingMediasAlert() {
        hasShownPendingMediasAlert = true
    }

    func openURL(_ url: URL) {
        hasOpenedURL = true
    }
}
