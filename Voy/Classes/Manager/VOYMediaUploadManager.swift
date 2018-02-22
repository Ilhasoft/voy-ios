//
//  VOYMediaUploadManager.swift
//  Voy
//
//  Created by Daniel Amaral on 20/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYMediaUploadManager: NSObject {

    static var isUploading = false
    
    static func upload(reportID: Int, cameraDataList:[VOYCameraData], completion:@escaping(Error?) -> Void) {
        for (_,cameraData) in cameraDataList.enumerated() {
            
            var report_id = reportID
            
            if reportID <= 0 {
                report_id = cameraData.report_id
            }
            
            if NetworkReachabilityManager()!.isReachable {
                isUploading = true
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
                        isUploading = false
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                                if response.error != nil {
                                    VOYCameraDataStorageManager.addAsPendent(cameraData: cameraData, reportID: report_id)
                                }else {
                                    VOYCameraDataStorageManager.removeFromStorageAfterSave(cameraData: cameraData)
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            VOYCameraDataStorageManager.addAsPendent(cameraData: cameraData, reportID: report_id)
                            //                        completion(encodingError)
                        }
                }
                )
            }else {
                VOYCameraDataStorageManager.addAsPendent(cameraData: cameraData, reportID: report_id)
            }
    
        }
        
        
        
    }
    
}
