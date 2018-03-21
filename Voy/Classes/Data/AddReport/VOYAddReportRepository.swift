//
//  VOYAddReportRepository.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAddReportRepository: VOYAddReportDataSource {

    let reachability: VOYReachability
    let networkClient = VOYNetworkClient(reachability: VOYDefaultReachability())
    let mediaFileDataSource: VOYMediaFileDataSource
    private let reportStorageManager = VOYReportStorageManager()

    init(reachability: VOYReachability, mediaFileDataSource: VOYMediaFileDataSource = VOYMediaFileRepository()) {
        self.reachability = reachability
        self.mediaFileDataSource = mediaFileDataSource
    }

    // MARK: - VOYAddReportDataSource

    func save(report: VOYReport, completion: @escaping (Error?, Int?) -> Void) {
        if reachability.hasNetwork() {
            saveRemote(report: report, completion: completion)
        } else {
            saveLocal(report: report, completion: completion)
        }
    }

    // MARK: - Private methods

    private func saveRemote(report: VOYReport, completion: @escaping (Error?, Int?) -> Void) {
        guard let authToken = VOYUser.activeUser()?.authToken else {
            return
        }
        let headers = ["Authorization": "Token \(authToken)"]
        var method: VOYNetworkClient.VOYHTTPMethod!
        var reportIDString = ""
        if let reportId = report.id, report.update && report.status != nil {
            method = .put
            reportIDString = "\(reportId)/"
        } else {
            method = .post
            reportIDString = ""
        }
        networkClient.requestDictionary(urlSuffix: "reports/\(reportIDString)",
            httpMethod: method,
            parameters: report.toJSON(),
            headers: headers) { (value, error, _) in
                guard let value = value else {
                    completion(error, nil)
                    return
                }
                if let reportID = value["id"] as? Int, let reportCameraDataList = report.cameraDataList {
                    self.mediaFileDataSource.delete(mediaFiles: report.removedMedias)
                    self.reportStorageManager.removeFromStorageAfterSave(report: report)
                    self.mediaFileDataSource.upload(
                        reportID: reportID,
                        cameraDataList: reportCameraDataList,
                        completion: { (_) in }
                    )
                    completion(nil, reportID)
                } else {
                    print("error: \(value)")
                    completion(nil, nil)
                }
        }
    }

    private func saveLocal(report: VOYReport, completion: @escaping (Error?, Int?) -> Void) {
        reportStorageManager.addAsPendent(report: report)
        completion(nil, nil)
    }
}
