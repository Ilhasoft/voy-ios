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
    var report: VOYReport

    init(view: VOYAddReportAttachContract, report: VOYReport = VOYReport()) {
        self.view = view
        self.report = report
    }

    func onViewDidLoad() {
        let mediaList: [VOYMedia] = report.files ?? []
        let cameraDataList: [VOYCameraData] = report.cameraDataList ?? []
        view?.loadFromReport(mediaList: mediaList, cameraDataList: cameraDataList)
    }

    func onNextButtonTapped() {
        view?.navigateToNextScreen(report: report)
    }

    func onCameraDataRemoved(_ cameraData: VOYCameraData) {
        report.removedCameraData.append(cameraData)
    }

    func onMediaRemoved(_ media: VOYMedia) {
        if var removedMedias = report.removedMedias {
            removedMedias.append(media)
        } else {
            report.removedMedias = [ media ]
        }
    }
}
