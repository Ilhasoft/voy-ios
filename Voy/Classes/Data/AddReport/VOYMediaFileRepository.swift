//
//  VOYMediaFileRepository.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYMediaFileRepository: VOYMediaFileDataSource {
    var isUploading = false
    private let networkClient = VOYNetworkClient(reachability: VOYDefaultReachability())
    private let reachability: VOYReachability
    private let camerDataStoreManager = VOYCameraDataStorageManager()

    init(reachability: VOYReachability = VOYDefaultReachability()) {
        self.reachability = reachability
    }

    func delete(mediaFiles: [VOYMedia]?) {
        guard let mediaFiles = mediaFiles else {return}
        guard let authToken = VOYUser.activeUser()?.authToken else { return }
        let mediaIds = mediaFiles.map {($0.id!)}
        var mediaIdsString = ""
        for mediaId in mediaIds {
            mediaIdsString = "\(mediaIdsString)\(mediaId),"
        }
        mediaIdsString.removeLast()
        networkClient.requestDictionary(urlSuffix: "report-files/delete/?ids=\(mediaIdsString)",
                                        httpMethod: .post,
                                        headers: ["Authorization": "Token \(authToken)"]) { value, error, _ in
            if let value = value {
                print(value)
            } else if let error = error {
                print (error)
            }
        }
    }

    func upload(reportID: Int, cameraDataList: [VOYCameraData], completion:@escaping(Error?) -> Void) {
        for cameraData in cameraDataList {

            var report_id = reportID

            if reportID <= 0 {
                report_id = cameraData.report_id
            }

            if reachability.hasNetwork() {
                isUploading = true
                guard let auth = VOYUser.activeUser()?.authToken,
                      let fileName = cameraData.fileName,
                      let filePath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) else { return }
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(
                            "\(report_id)".data(using: String.Encoding.utf8)!,
                            withName: "report_id"
                        )
                        multipartFormData.append(
                            "title".data(using: String.Encoding.utf8)!,
                            withName: "title"
                        )
                        multipartFormData.append(
                            URL(fileURLWithPath: filePath),
                            withName: "file"
                        )
                        if let thumbnailFileName = cameraData.thumbnailFileName,
                           let thumbnailPath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(thumbnailFileName),
                           cameraData.type == VOYMediaType.video {
                            multipartFormData.append(
                                URL(fileURLWithPath: thumbnailPath), withName: "thumbnail"
                            )
                        }
                },
                    to: VOYConstant.API.URL + "report-files/",
                    method: .post,
                    headers: ["Authorization": "Token \(auth)"],
                    encodingCompletion: { encodingResult in
                        self.isUploading = false
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                                if response.error != nil {
                                    self.camerDataStoreManager.addAsPendent(cameraData: cameraData, reportID: report_id)
                                } else {
                                    self.camerDataStoreManager.removeFromStorageAfterSave(cameraData: cameraData)
                                }
                            }
                        case .failure:
                            self.camerDataStoreManager.addAsPendent(cameraData: cameraData, reportID: report_id)
                        }
                })
            } else {
                camerDataStoreManager.addAsPendent(cameraData: cameraData, reportID: report_id)
            }
        }
    }
}
