//
//  VOYReportSyncManager.swift
//  Voy
//
//  Created by Daniel Amaral on 21/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportSyncManager {

    private let mediaFileDataSource: VOYMediaFileDataSource
    private let reachability: VOYReachability
    private let reportStoreManager = VOYReportStorageManager()
    private let cameraDataStoreManager = VOYCameraDataStorageManager()

    private var isAllowedToSync = true

    init(mediaFileDataSource: VOYMediaFileDataSource = VOYMediaFileRepository(),
         reachability: VOYReachability = VOYDefaultReachability()) {
        self.mediaFileDataSource = mediaFileDataSource
        self.reachability = reachability
    }

    func trySendPendentReports() {
        guard isAllowedToSync else { return }
        let pendentReportsJSON = reportStoreManager.getPendentReports()
        guard !pendentReportsJSON.isEmpty else {
            return
        }
        guard reachability.hasNetwork() else {
            return
        }
        for reportJSON in pendentReportsJSON {
            if let report = VOYReport(JSON: reportJSON) {
                VOYAddReportRepository(reachability: reachability).save(report: report) { (_, _) in }
            }
        }
    }

    func trySendPendentCameraData() {
        guard isAllowedToSync, reachability.hasNetwork() else { return }
        let pendentCameraDataListDictionary = cameraDataStoreManager.getPendentCameraDataList()
        var cameraDataList = [VOYCameraData]()
        guard !pendentCameraDataListDictionary.isEmpty else {
            return
        }
        for cameraDataDictionary in pendentCameraDataListDictionary {
            if let cameraData = VOYCameraData(JSON: cameraDataDictionary) {
                cameraDataList.append(cameraData)
            }
        }
        guard !mediaFileDataSource.isUploading else { return }
        mediaFileDataSource.upload(reportID: 0, cameraDataList: cameraDataList) { (_) in }
    }
}
