//
//  VOYMockCommentViewController.swift
//  VoyTests
//
//  Created by Dielson Sales on 26/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYMockCommentViewController: VOYCommentContract {

    var viewModel: VOYCommentViewModel?
    var hasShownCommentSent = false
    var hasSetImage = false
    var isShowingProgress = false

    func update(with viewModel: VOYCommentViewModel) {
        self.viewModel = viewModel
    }

    func showCommentSentAlert() {
        hasShownCommentSent = true
    }

    func setImage(image: UIImage, at position: Int) {
        hasSetImage = true
    }

    func showProgress() {
        isShowingProgress = true
    }

    func hideProgress() {
        isShowingProgress = false
    }

}
