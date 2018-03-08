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
    static let shared = VOYMediaFileRepository()
    static var isUploading = false
    
    func delete(mediaFiles:[VOYMedia]?) {
        guard let mediaFiles = mediaFiles else {return}
        
        let authToken = VOYUser.activeUser()!.authToken!
        
        let mediaIds = mediaFiles.map {($0.id!)}
        var mediaIdsString = ""
        for mediaId in mediaIds {
            mediaIdsString = mediaIdsString + "\(mediaId)" + ","
        }
        mediaIdsString.removeLast()
        let url = VOYConstant.API.URL + "report-files/delete/?ids=" + mediaIdsString
        let headers:HTTPHeaders = ["Authorization" : "Token " + authToken]
        
        Alamofire.request(url, method: .post , headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
            if let value = dataResponse.result.value {
                print(value)
            }else if let error = dataResponse.result.error {
                print(error.localizedDescription)
            }
        }
    }
    
    func upload(reportID: Int, cameraDataList:[VOYCameraData], completion:@escaping(Error?) -> Void) {
        for (_,cameraData) in cameraDataList.enumerated() {
            
            var report_id = reportID
            
            if reportID <= 0 {
                report_id = cameraData.report_id
            }
            
            if NetworkReachabilityManager()!.isReachable {
                VOYMediaFileRepository.isUploading = true
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
                    method:.post,
                    headers: ["Authorization" : "Token " + VOYUser.activeUser()!.authToken],
                    encodingCompletion: { encodingResult in
                        VOYMediaFileRepository.isUploading = false
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                                if response.error != nil {
                                    VOYCameraDataStorageManager.shared.addAsPendent(cameraData: cameraData, reportID: report_id)
                                }else {
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
