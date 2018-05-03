//
//  VOYReportListPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 09/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

enum VOYAddReportErrorType {
    case willStart
    case ended
    case outOfBouds

    func getMessage() -> String {
        var alertText: String = ""
        switch self {
        case .willStart:
            alertText = localizedString(.weArePreparingThisTheme)
        case .ended:
            alertText = localizedString(.periodForReportEnded)
        case .outOfBouds:
            alertText = localizedString(.outsideThemesBounds)
        }
        return alertText
    }
}

class VOYReportListPresenter {

    private weak var view: VOYReportListContract?
    private var dataSource: VOYReportListDataSource!
    var countApprovedReports: Int?
    var countPendingReports: Int?
    var countNotApprovedReports: Int?

    init(view: VOYReportListContract, dataSource: VOYReportListDataSource) {
        self.view = view
        self.dataSource = dataSource
    }

    func onAddReportAction() {
        guard let theme = VOYTheme.activeTheme() else { return }
        if let error = getDateError(theme: theme, currentDate: Date()) {
            view?.showAlert(text: error.getMessage())
        } else {
            view?.navigateToAddReport()
        }
    }

    func onReportSelected(object: [String: Any]) {
        if let report = VOYReport(JSON: object)  {
            view?.navigateToReportDetails(report: report)
        }
    }

    func countReports(themeId: Int, status: VOYReportStatus, mapper: Int) {
        switch status {
        case .approved:
            dataSource.getReportCount(themeId: themeId, status: status, mapper: mapper) { count, _ in
                self.countApprovedReports = count
            }
        case .pendent:
            dataSource.getReportCount(themeId: themeId, status: status, mapper: mapper) { count, _ in
                self.countPendingReports = count
            }
        case .notApproved:
            dataSource.getReportCount(themeId: themeId, status: status, mapper: mapper) { count, _ in
                self.countNotApprovedReports = count
            }
        }
    }

    // MARK: Private methods

    private func getDateError(theme: VOYTheme, currentDate: Date) -> VOYAddReportErrorType? {
        guard var startAt = theme.start_at, var endAt = theme.end_at else { return nil } // No errors here
        startAt = "\(startAt) 00:00"
        endAt = "\(endAt) 23:59"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "UTC")

        guard let startDate = dateFormatter.date(from: startAt),
            let endDate = dateFormatter.date(from: endAt) else { return nil }

        if startDate >= currentDate || endDate <= currentDate {
            return (startDate >= currentDate) ? .willStart : .ended
        } else {
            return nil
        }
    }
}
