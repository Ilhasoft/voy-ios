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

    static func save(report:VOYReport, completion:@escaping(Error?,Int?) -> Void) {
        
        let url = VOYConstant.API.URL + "reports/"
        let authToken = VOYUser.activeUser()!.authToken
        
        let headers = ["Authorization" : "Token " + authToken!, "Content-Type" : "application/json"]
        
        if NetworkReachabilityManager()!.isReachable {
            Alamofire.request(url, method: .post, parameters: report.toJSON(), encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
                if let error = dataResponse.result.error {
                    completion(error, nil)
                }else if let value = dataResponse.result.value as? [String:Any] {
                    if let reportID = value["id"] as? Int {
                        completion(nil, reportID)
                    }else {
                        print("error: \(value)")
                        completion(nil, nil)
                    }
                }
            }
        }else {
            VOYReportStorageManager.addAsPendent(report: report)
            completion(nil,nil)
        }
        
    }
    
}
