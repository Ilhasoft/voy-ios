//
//  VOYAddReportTagsPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAddReportTagsPresenter {
    var dataSource: VOYAddReportDataSource!
    var view: VOYAddReportTagsContract?
    private var report: VOYReport?
    
    init(report: VOYReport?, dataSource: VOYAddReportDataSource, view: VOYAddReportTagsContract) {
        self.report = report
        self.dataSource = dataSource
        self.view = view
    }

    func onViewDidLoad() {
        guard let activeTheme = assertExists(optionalVar: VOYTheme.activeTheme()) else { return }
        if let tags = report?.tags {
            view?.loadTags(themeTags: activeTheme.tags, selectedTags: tags)
        } else {
            view?.loadTags(themeTags: activeTheme.tags, selectedTags: [])
        }
    }
    
    func saveReport(selectedTags: [String]) {
        guard let report = self.report, let activeTheme = VOYTheme.activeTheme() else { return }
        report.tags = selectedTags
        report.theme = activeTheme.id
        let location = "POINT(\(VOYLocationData.longitude) \(VOYLocationData.latitude))"
        report.location = location

        view?.showProgress()
        dataSource.save(report: report) { error, _ in
            self.view?.dismissProgress()
            if error == nil {
                self.view?.navigateToSuccessScreen()
            } else {
                // TODO: navigate to error
            }
        }
    }
}
