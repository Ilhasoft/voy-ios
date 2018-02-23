//
//  VOYMediaUploadManager.swift
//  Voy
//
//  Created by Daniel Amaral on 20/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYMediaFileInteractor: NSObject {

    static let shared = VOYMediaFileInteractor()
    
    static var isUploading = false
    
    func delete(mediaFiles:[VOYMedia]?) -> Void {
        guard let mediaFiles = mediaFiles else {return}
        let mediaIds = mediaFiles.map {($0.id!)}
        var mediaIdsString = ""
        for mediaId in mediaIds {
            mediaIdsString = mediaIdsString + "\(mediaId)" + ","
        }
        mediaIdsString.removeLast()
        let url = VOYConstant.API.URL + "report-files/" + mediaIdsString
        var headers = ["Authorization" : "Token " + VOYUser.activeUser()!.authToken]
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
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
                VOYMediaFileInteractor.isUploading = true
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append("\(report_id)".data(using: String.Encoding.utf8)!, withName: "report_id")
                        multipartFormData.append("title".data(using: String.Encoding.utf8)!, withName: "title")
                        multipartFormData.append(URL(fileURLWithPath: cameraData.path), withName: "file")
                },
                    to: VOYConstant.API.URL + "report-files/",
                    method:.post,
                    headers: ["Authorization" : "Token " + VOYUser.activeUser()!.authToken],
                    encodingCompletion: { encodingResult in
                        VOYMediaFileInteractor.isUploading = false
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
                            //                        completion(encodingError)
                        }
                }
                )
            }else {
                VOYCameraDataStorageManager.shared.addAsPendent(cameraData: cameraData, reportID: report_id)
            }
    
        }
        
    }
    
}
