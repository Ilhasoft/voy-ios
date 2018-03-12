//
//  VOYMockReportListViewController.swift
//  VoyTests
//
//  Created by Dielson Sales on 12/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYMockReportListViewController: VOYReportListContract {
    
    var hasNavigatedToReportDetails = false
    
    func navigateToReportDetails(report: VOYReport) {
        hasNavigatedToReportDetails = true
    }
}
