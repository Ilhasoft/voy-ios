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
    var view: VOYAddReportTagsContract!
    
    init(dataSource: VOYAddReportDataSource, view: VOYAddReportTagsContract) {
        self.dataSource = dataSource
        self.view = view
    }
    
    func saveReport(report: VOYReport) {
        view.startLoadingAnimation()
        dataSource.save(report: report) { (error, _) in
            self.view.stopLoadingAnimation()
            if error == nil {
                self.view.showSuccess()
            }
        }
    }
}
