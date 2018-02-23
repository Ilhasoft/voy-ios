//
//  VOYAddReportInteractor.swift
//  Voy
//
//  Created by Daniel Amaral on 20/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYAddReportInteractor: NSObject {

    static let shared = VOYAddReportInteractor()
    
    func save(report:VOYReport, completion:@escaping(Error?,Int?) -> Void) {
        let reportIDString = report.id == nil ? "" : "\(report.id!)"
        let url = VOYConstant.API.URL + "reports/" + reportIDString
        let authToken = VOYUser.activeUser()!.authToken
        
        let headers = ["Authorization" : "Token " + authToken!, "Content-Type" : "application/json"]
        
        if NetworkReachabilityManager()!.isReachable {
            Alamofire.request(url, method: .post, parameters: report.toJSON(), encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
                if let error = dataResponse.result.error {
                    completion(error, nil)
                }else if let value = dataResponse.result.value as? [String:Any] {
                    if let reportID = value["id"] as? Int {
                        VOYMediaFileInteractor.shared.delete(mediaFiles: report.removedMedias)
                        VOYReportStorageManager.shared.removeFromStorageAfterSave(report: report)
                        VOYMediaFileInteractor.shared.upload(reportID: reportID, cameraDataList: report.cameraDataList!, completion: { (error) in
                        })
                        completion(nil, reportID)
                    }else {
                        print("error: \(value)")
                        completion(nil, nil)
                    }
                }
            }
        }else {
            VOYReportStorageManager.shared.addAsPendent(report: report)
            completion(nil,nil)
        }
        
    }
    
}
