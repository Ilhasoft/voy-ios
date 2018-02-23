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

    static let shared = VOYReportSyncManager()
    
    func trySendPendentReports() {
        let pendentReportsJSON = VOYReportStorageManager.shared.getPendentReports()
        guard !pendentReportsJSON.isEmpty else {
            return
        }
        
        guard NetworkReachabilityManager()!.isReachable else {
            return
        }
        
        for reportJSON in pendentReportsJSON {
            VOYAddReportInteractor.shared.save(report: VOYReport(JSON:reportJSON)!, completion: { (error, reportID) in })
        }
    }
    
    func trySendPendentCameraData() {
        let pendentCameraDataListDictionary = VOYCameraDataStorageManager.shared.getPendentCameraDataList()
        var cameraDataList = [VOYCameraData]()
        
        guard !pendentCameraDataListDictionary.isEmpty else {
            return
        }
        
        for cameraDataDictionary in pendentCameraDataListDictionary {
            let cameraData = VOYCameraData(JSON:cameraDataDictionary)!
            cameraDataList.append(cameraData)
        }
        
        guard NetworkReachabilityManager()!.isReachable else {
            return
        }
        
        guard !VOYMediaUploadManager.isUploading else { return }
        
        VOYMediaUploadManager.shared.upload(reportID: 0, cameraDataList: cameraDataList) { (error) in }
    }
    
}
