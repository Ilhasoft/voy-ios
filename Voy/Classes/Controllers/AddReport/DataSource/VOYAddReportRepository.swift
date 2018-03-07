//
//  VOYAddReportRepository.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYAddReportRepository: VOYAddReportDataSource {
    func save(report: VOYReport, completion: @escaping (Error?, Int?) -> Void) {
        let authToken = VOYUser.activeUser()!.authToken
        
        let headers = ["Authorization" : "Token " + authToken!, "Content-Type" : "application/json"]
        
        var method:HTTPMethod!
        var reportIDString = ""
        
        if report.update && report.status != nil {
            method = HTTPMethod.put
            reportIDString = "\(report.id!)/"
        } else {
            method = HTTPMethod.post
            reportIDString = ""
        }
        
        let url = VOYConstant.API.URL + "reports/" + reportIDString
        
        if NetworkReachabilityManager()!.isReachable {
            Alamofire.request(url, method: method, parameters: report.toJSON(), encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
                if let error = dataResponse.result.error {
                    print(error)
                    completion(error, nil)
                } else if let value = dataResponse.result.value as? [String:Any] {
                    if let reportID = value["id"] as? Int {
                        VOYMediaFileInteractor.shared.delete(mediaFiles: report.removedMedias)
                        VOYReportStorageManager.shared.removeFromStorageAfterSave(report: report)
                        VOYMediaFileInteractor.shared.upload(reportID: reportID, cameraDataList: report.cameraDataList!, completion: { (error) in
                        })
                        completion(nil, reportID)
                    } else {
                        print("error: \(value)")
                        completion(nil, nil)
                    }
                }
            }
        } else {
            VOYReportStorageManager.shared.addAsPendent(report: report)
            completion(nil, nil)
        }
    }
    

}
