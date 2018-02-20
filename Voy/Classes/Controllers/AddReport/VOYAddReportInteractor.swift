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

    static func save(report:VOYReport, completion:@escaping(Error?) -> Void) {
        
        let url = VOYConstant.API.URL + "reports/"
        let authToken = VOYUser.activeUser()!.authToken
        
        let headers = ["Authorization" : "Token " + authToken!, "Content-Type" : "application/json"]
        
        Alamofire.request(url, method: .post, parameters: report.toJSON(), encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
            if let error = dataResponse.result.error {
                completion(error)
            }else if let value = dataResponse.result.value as? [String:Any] {
                print(value)
                completion(nil)
            }
        }
        
    }
    
}
