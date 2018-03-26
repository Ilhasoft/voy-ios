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
        let handler: ([String: Any]?, Error?) -> Void = { value, error in
            guard let value = value else {
                completion(error, nil)
                return
            }
            if let tags = value["tags"] as? [String] {
                print("\(tags)")
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
        if let reportId = report.id, report.update && report.status != nil {
            updateRemote(reportId: reportId, report: report, completion: handler)
        } else {
            createRemote(report: report, completion: handler)
        }
    }

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

    private func saveLocal(report: VOYReport, completion: @escaping (Error?, Int?) -> Void) {
        reportStorageManager.addAsPendent(report: report)
        completion(nil, nil)
    }
}
