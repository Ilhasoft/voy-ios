//
//  VOYMockThemesViewController.swift
//  VoyTests
//
//  Created by Dielson Sales on 20/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation
@testable import Voy

class VOYMockThemesViewController: VOYThemesContract {

    var viewModel: VOYThemesViewModel?
    var isShowingProgress = false
    var hasRedirectedToReportsScreen = false
    var hasRedirectedToProfileScreen = false
    var hasToggledNotification = false
    var badgeIsVisible = false
    var hasUpdatedUserData = false

    func update(with viewModel: VOYThemesViewModel) {
        self.viewModel = viewModel
    }

    func showProgress() {
        isShowingProgress = true
    }

    func dismissProgress() {
        isShowingProgress = false
    }

    func navigateToReportsScreen() {
        hasRedirectedToReportsScreen = true
    }

    func navigateToProfileScreen() {
        hasRedirectedToProfileScreen = true
    }

    func toggleNotifications() {
        hasToggledNotification = true
    }

    func updateUserData(user: VOYUser) {
        hasUpdatedUserData = true
    }

    func setNotificationBadge(hidden: Bool) {
        badgeIsVisible = !hidden
    }
}
