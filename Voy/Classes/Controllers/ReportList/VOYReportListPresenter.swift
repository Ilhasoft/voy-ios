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
    
    init(view: VOYReportListContract) {
        self.view = view
    }
    
    func onReportSelected(object: [String: Any]) {
        if let report = VOYReport(JSON: object) {
            view?.navigateToReportDetails(report: report)
        }
    }

}
