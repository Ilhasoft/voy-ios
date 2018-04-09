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
    let storageManager: VOYStorageManager

    init(reachability: VOYReachability,
         mediaFileDataSource: VOYMediaFileDataSource = VOYMediaFileRepository(),
         storageManager: VOYStorageManager = VOYDefaultStorageManager()) {
        self.reachability = reachability
        self.mediaFileDataSource = mediaFileDataSource
        self.storageManager = storageManager
    }

    // MARK: - VOYAddReportDataSource

    func save(report: VOYReport) {
        guard reachability.hasNetwork() else { return }

        if let reportId = report.id, report.update && report.status != nil {
            updateRemote(reportId: reportId, report: report) { value, error in
                if let value = value, let reportID = value["id"] as? Int, let cameraDataList = report.cameraDataList {
                    self.mediaFileDataSource.delete(mediaFiles: report.removedMedias)
                    self.storageManager.removeFromPendingList(report: report)
                    for cameraData in cameraDataList {
                        self.storageManager.addAsPending(cameraData: cameraData, reportID: reportID)
                    }
                }
            }
        } else {
            createRemote(report: report) { value, error in
                if let value = value, let reportID = value["id"] as? Int, let cameraDataList = report.cameraDataList {
                    self.mediaFileDataSource.delete(mediaFiles: report.removedMedias)
                    self.storageManager.removeFromPendingList(report: report)
                    for cameraData in cameraDataList {
                        self.storageManager.addAsPending(cameraData: cameraData, reportID: reportID)
                    }
                }
            }
        }
    }

    func saveLocal(report: VOYReport) {
        storageManager.addPendingReport(report)
    }

    // MARK: - Private methods

    private func createRemote(report: VOYReport, completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let authToken = VOYUser.activeUser()?.authToken else {
            return
        }
        let headers = ["Authorization": "Token \(authToken)"]
        let params = report.toJSON()
        networkClient.requestDictionary(urlSuffix: "reports/",
            httpMethod: .post,
            parameters: params,
            headers: headers,
            useJSONEncoding: true) { (value, error, _) in
                completion(value, error)
        }
    }

    private func updateRemote(reportId: Int,
                              report: VOYReport,
                              completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let authToken = VOYUser.activeUser()?.authToken else {
            return
        }
        let headers = ["Authorization": "Token \(authToken)"]
        let params = report.toJSON()
        let urlSuffix = "reports/\(reportId)/"
        networkClient.requestDictionary(urlSuffix: urlSuffix,
            httpMethod: .put,
            parameters: params,
            headers: headers,
            useJSONEncoding: true) { (value, error, _) in
                completion(value, error)
        }
    }
}
