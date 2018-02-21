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

    static func upload(reportID:Int, cameraDataList:[VOYCameraData], completion:@escaping(Error?) -> Void) {
        
        for (index,cameraData) in cameraDataList.enumerated() {            
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append("\(reportID)".data(using: String.Encoding.utf8)!, withName: "report_id")
                    multipartFormData.append("title".data(using: String.Encoding.utf8)!, withName: "title")
                    if cameraData.type == .video {
                        multipartFormData.append(URL(fileURLWithPath: cameraData.path!.path), withName: "file")
                    }else {
                        multipartFormData.append(UIImageJPEGRepresentation(cameraData.image!, 0.2)!, withName: "file", fileName: "image.jpg", mimeType: "image/jpg")
                    }
                    
                },
                to: VOYConstant.API.URL + "report-files/",
                method:.post,
                headers: ["Authorization" : "Token " + VOYUser.activeUser()!.authToken],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            if index == cameraDataList.count - 1 {
                                completion(nil)
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        completion(encodingError)
                    }
                }
            )
        }
        
        
        
    }
    
}
