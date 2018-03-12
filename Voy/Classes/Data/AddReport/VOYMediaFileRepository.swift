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
    private let networkClient = VOYNetworkClient(reachability: VOYReachabilityImpl())
    private let reachability: VOYReachability
    
    init(reachability: VOYReachability = VOYReachabilityImpl()) {
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
        let headers: HTTPHeaders = ["Authorization": "Token \(authToken)"]
        
        networkClient.requestDictionary(urlSuffix: "report-files/delete/?ids=\(mediaIdsString)",
                                        httpMethod: .post,
                                        headers: headers) { value, error, _ in
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
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append("\(report_id)".data(using: String.Encoding.utf8)!, withName: "report_id")
                        multipartFormData.append("title".data(using: String.Encoding.utf8)!, withName: "title")
                        multipartFormData.append(URL(fileURLWithPath: cameraData.path), withName: "file")
                        if cameraData.type == VOYMediaType.video {
                            multipartFormData.append(URL(fileURLWithPath: cameraData.thumbnailPath!), withName: "thumbnail")
                        }
                },
                    to: VOYConstant.API.URL + "report-files/",
                    method: .post,
                    headers: ["Authorization": "Token " + VOYUser.activeUser()!.authToken],
                    encodingCompletion: { encodingResult in
                        self.isUploading = false
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                                if response.error != nil {
                                    VOYCameraDataStorageManager.shared.addAsPendent(cameraData: cameraData, reportID: report_id)
                                } else {
                                    VOYCameraDataStorageManager.shared.removeFromStorageAfterSave(cameraData: cameraData)
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            VOYCameraDataStorageManager.shared.addAsPendent(cameraData: cameraData, reportID: report_id)
                        }
                })
            } else {
                VOYCameraDataStorageManager.shared.addAsPendent(cameraData: cameraData, reportID: report_id)
            }
        }
    }
}
