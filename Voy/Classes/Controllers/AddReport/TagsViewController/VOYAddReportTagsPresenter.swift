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
        view?.loadTags()
        if let tags = report?.tags {
            view?.selectTags(tags: tags)
        }
    }
    
    func saveReport(selectedTags: [String]) {
        guard let report = self.report else { return }
        report.tags = selectedTags
        report.theme = VOYTheme.activeTheme()!.id
        let location = "POINT(\(VOYLocationData.longitude) \(VOYLocationData.latitude))"
        report.location = location

        view?.showProgress()
        dataSource.save(report: report) { error, _ in
            self.view?.dismissProgress()
            if error == nil {
                self.view?.navigateToSuccessScreen()
            }
        }
    }
}
