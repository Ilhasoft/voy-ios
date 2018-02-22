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
    
    static func trySendPendentCameraData() {
        let pendentCameraDataListDictionary = VOYCameraDataStorageManager.getPendentCameraDataList()
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
        
        VOYMediaUploadManager.upload(reportID: 0, cameraDataList: cameraDataList) { (error) in }
    }
    
}
