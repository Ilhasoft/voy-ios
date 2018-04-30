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
    private let storageManager: VOYStorageManager

    init(reachability: VOYReachability = VOYDefaultReachability(),
         storageManager: VOYStorageManager = VOYDefaultStorageManager()) {
        self.reachability = reachability
        self.storageManager = storageManager
    }

    func delete(mediaFiles: [VOYMedia]?) {
        guard let mediaFiles = mediaFiles else {return}
        let mediaIdsList = mediaFiles.map { $0.id }
        var mediaIdsString = ""
        for mediaId in mediaIdsList {
            if let mediaId = mediaId {
                mediaIdsString = "\(mediaIdsString)\(mediaId),"
            }
        }
        mediaIdsString.removeLast()
        networkClient.requestDictionary(urlSuffix: "report-files/delete/?ids=\(mediaIdsString)",
                                        httpMethod: .post,
                                        headers: networkClient.authorizationHeaders) { value, error, _ in
            if let value = value {
                print(value)
            } else if let error = error {
                print (error)
            }
        }
    }

    func upload(reportID: Int, cameraData: VOYCameraData, completion: @escaping (Error?) -> Void) {
        var report_id = reportID
        if reportID <= 0 {
            report_id = cameraData.report_id
        }
        if reachability.hasNetwork() && !isUploading {
            isUploading = true
            guard let fileName = cameraData.fileName,
                let filePath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) else { return }
            Alamofire.upload(multipartFormData: { multipartFormData in
                    if let reportIdData = "\(report_id)".data(using: String.Encoding.utf8) {
                        multipartFormData.append(reportIdData, withName: "report_id")
                    }
                    if let titleData = "title".data(using: String.Encoding.utf8) {
                        multipartFormData.append(titleData, withName: "title")
                    }
                    multipartFormData.append(
                        URL(fileURLWithPath: filePath),
                        withName: "file"
                    )
                    if let thumbFileName = cameraData.thumbnailFileName,
                        let thumbnailPath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(thumbFileName),
                        cameraData.type == VOYMediaType.video {
                        multipartFormData.append(URL(fileURLWithPath: thumbnailPath), withName: "thumbnail")
                    }
            },
                to: "\(VOYConstant.API.URL)report-files/",
                method: .post,
                headers: networkClient.authorizationHeaders,
                encodingCompletion: { encodingResult in
                    self.isUploading = false
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if response.error != nil {
                                self.storageManager.addAsPending(cameraData: cameraData, reportID: report_id)
                            } else {
                                self.storageManager.removeFromPendingList(cameraData: cameraData)
                            }
                        }
                    case .failure:
                        self.storageManager.addAsPending(cameraData: cameraData, reportID: report_id)
                    }
            })
        } else {
            storageManager.addAsPending(cameraData: cameraData, reportID: report_id)
        }
    }
}
