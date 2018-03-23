//
//  VOYReportDetailPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportDetailPresenter {

    private weak var view: VOYReportDetailContract?
    var report: VOYReport!

    init(view: VOYReportDetailContract, report: VOYReport) {
        self.view = view
        self.report = report
    }

    func onViewDidLoad() {
        guard let reportStatusRawValue = report.status,
              let reportStatus = VOYReportStatus(rawValue: reportStatusRawValue) else {
            view?.setCommentButtonEnabled(false)
            return
        }

        switch reportStatus {
        case .approved:
            view?.setCommentButtonEnabled(true)
        default:
            view?.setCommentButtonEnabled(false)
        }
    }

    func onCommentButtonTapped() {
        view?.navigateToCommentsScreen(report: report)
    }

    func onOptionsButtonTapped() {
        view?.showActionSheet()
    }

    func onShareButtonTapped() {
        guard let reportId = self.report.id else { return }
        let textToShare = localizedString(.reportedAProblem, andText: report.shareURL)
        view?.shareText(textToShare)
    }

    func onTapImage(image: UIImage?) {
        if let image = image {
            view?.showPictureScreen(image: image)
        }
    }

    func onTapVideo(videoURL: URL) {
        view?.showVideoScreen(videoURL: videoURL)
    }

    func onTapEditReport() {
        view?.navigateToEditReportScreen(report: self.report)
    }
}
