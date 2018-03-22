//
//  VOYReportListPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 09/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

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
    
    func onReportSelected(object: [String: Any]) {
        if let report = VOYReport(JSON: object) {
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
}
