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
    private let storageManager = VOYStorageManager()

    private let dataSource: VOYAddReportDataSource!

    private var isAllowedToSync = true

    init(mediaFileDataSource: VOYMediaFileDataSource = VOYMediaFileRepository(),
         reachability: VOYReachability = VOYDefaultReachability()) {
        self.mediaFileDataSource = mediaFileDataSource
        self.reachability = reachability
        dataSource = VOYAddReportRepository(reachability: reachability)
    }

    func trySendPendentReports() {
        guard isAllowedToSync else { return }
        let pendentReportsJSON = storageManager.getPendentReports()
        guard !pendentReportsJSON.isEmpty else { return }
        guard reachability.hasNetwork() else { return }
        for reportJSON in pendentReportsJSON {
            if let report = VOYReport(JSON: reportJSON) {
                dataSource.save(report: report)
            }
        }
    }

    func trySendingNextPendingCameraData() {
        print("isAllowedToSync: \(isAllowedToSync), hastNetwork: \(reachability.hasNetwork()), isUploading: \(mediaFileDataSource.isUploading)")
        guard isAllowedToSync, reachability.hasNetwork(), !mediaFileDataSource.isUploading else { return }
        let pendentCameraDataListDictionary = storageManager.getPendingCameraDataList()
        guard let cameraData = pendentCameraDataListDictionary.first else { return }
        guard let cameraDataObject = VOYCameraData(JSON: cameraData) else { return }
        mediaFileDataSource.upload(reportID: 0, cameraData: cameraDataObject) { _ in }
    }
}
