//
//  VOYCommentInteractor.swift
//  Voy
//
//  Created by Daniel Amaral on 26/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYCommentInteractor: NSObject {

    static let shared = VOYCommentInteractor()
    
    func save(comment:VOYComment, completion:@escaping (Error?) -> Void) {
        
        let authToken = VOYUser.activeUser()!.authToken!
        let url = VOYConstant.API.URL + "report-comments/"
        let headers = ["Authorization" : "Token " + authToken, "Content-Type" : "application/json"]
        
        Alamofire.request(url, method: .post, parameters: comment.toJSON(), encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
            if let _ = dataResponse.result.value {
                completion(nil)
            }else if let error = dataResponse.result.error {
                print(error.localizedDescription)
                completion(error)
            }
        }
        
    }
    
}
