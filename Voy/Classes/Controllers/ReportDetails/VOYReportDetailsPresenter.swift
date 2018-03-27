//
//  VOYReportDetailsPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 27/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation

class VOYReportDetailsPresenter {

    private let report: VOYReport
    private weak var view: VOYReportDetailsContract?

    init(report: VOYReport, view: VOYReportDetailsContract) {
        self.report = report
        self.view = view
    }

    func onViewDidLoad() {
        guard let theme = assertExists(optionalVar: VOYTheme.activeTheme()) else { return }
        let dateString = formatDate(createdOnDate: report.created_on)
        view?.setupText(title: report.name, date: dateString, description: report.description, tags: report.tags)
        view?.setThemeColor(themeColorHex: theme.color)
        view?.setMedias(report.files)
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
