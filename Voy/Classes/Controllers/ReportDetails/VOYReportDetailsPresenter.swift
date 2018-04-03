//
//  VOYReportDetailsPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 27/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportDetailsPresenter {

    private let report: VOYReport
    private weak var view: VOYReportDetailsContract?

    init(report: VOYReport, view: VOYReportDetailsContract) {
        self.report = report
        self.view = view
    }

    func onViewDidLoad() {
        guard let theme = assertExists(optionalVar: VOYTheme.activeTheme()) else { return }
        guard let activeUser = VOYUser.activeUser() else { return }
        guard let avatarURL = URL(string: activeUser.avatar) else { return }

        var dateString = ""
        if let createdOn = report.created_on {
            dateString = formatDate(createdOnDate: createdOn)
        }

        view?.setupText(
            title: report.name,
            date: dateString,
            description: report.description,
            tags: report.tags.sorted()
        )
        view?.setThemeColor(themeColorHex: theme.color)

        if let reportFiles = report.files {
            view?.setMedias(reportFiles)
        }

        // Only allow comments in approved reports
        if let reportStatus = report.status, reportStatus == VOYReportStatus.approved.rawValue {
            view?.setCommentButtonEnabled(true)
        } else {
            view?.setCommentButtonEnabled(false)
        }

        var reportIsApproved = false
        if let status = report.status, status == VOYReportStatus.approved.rawValue {
            reportIsApproved = true
        }
        view?.setupNavigationButtons(
            avatarURL: avatarURL,
            lastNotification: report.lastNotification,
            showOptions: !reportIsApproved,
            showShare: reportIsApproved
        )

        // Offline report
        if let cameraDataList = report.cameraDataList {
            view?.setCameraData(cameraDataList)
        }
    }

    func onTapImage(image: UIImage?) {
        if let image = image {
            view?.navigateToPictureScreen(image: image)
        }
    }

    func onTapVideo(videoURL: URL) {
        view?.navigateToVideoScreen(videoURL: videoURL)
    }

    func onTapCommentsButton() {
        view?.navigateToCommentsScreen(report: report)
    }

    func onTapEditReport() {
        view?.navigateToEditReport(report: report)
    }

    func onTapSharedButton() {
        let textToShare = localizedString(.reportedAProblem, andText: report.shareURL)
        view?.shareText(textToShare)
    }

    func onTapOptionsButton() {
        view?.showOptionsActionSheet()
    }

    func onTapIssueButton() {
        guard let lastNotification = report.lastNotification else { return }
        view?.showIssueAlert(lastNotification: lastNotification)
    }

    // MARK: - Private methods

    /**
     * Turns the date returned from the API into a readable date for the user
     */
    private func formatDate(createdOnDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = localizedString(.dateFormat)
        let date = dateFormatter.date(from: createdOnDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM"
        dateFormatter2.dateStyle = .medium

        var dateString = ""
        if let date = date {
            dateString = dateFormatter2.string(from: date)
        }
        return dateString
    }
}
