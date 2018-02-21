//
//  VOYReportSyncManager.swift
//  Voy
//
//  Created by Daniel Amaral on 21/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYReportSyncManager: NSObject {

    static func trySendPendentReports() {
        let pendentReportsJSON = VOYReportStorageManager.getPendentReports()
        guard !pendentReportsJSON.isEmpty else {
            return
        }
        
        guard NetworkReachabilityManager()!.isReachable else {
            return
        }
        
        for reportJSON in pendentReportsJSON {
            VOYAddReportInteractor.save(report: VOYReport(JSON:reportJSON)!, completion: { (error, reportID) in })
        }
    }
    
}
