//
//  VOYAddReportAttachPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 15/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAddReportAttachPresenter {

    weak var view: VOYAddReportAttachContract?

    init(view: VOYAddReportAttachContract) {
        self.view = view
    }

    func onNextButtonTapped() {
        view?.navigateToNextScreen()
    }
}
