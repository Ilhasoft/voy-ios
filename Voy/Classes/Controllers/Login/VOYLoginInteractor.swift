//
//  VOYLoginInteractor.swift
//  Voy
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire
import RestBind

class VOYLoginInteractor: NSObject {

    static func login(username:String, password:String, completion:@escaping(_ user:VOYUser?, _ error:Error?) -> Void) {
        let params = ["username":username,"password":password]
        
        Alamofire.request(VOYConstant.API.URL + "get_auth_token/", method: .post, parameters: params).responseJSON { (dataResponse:DataResponse<Any>) in
            if let authTokenData = dataResponse.result.value as? [String:Any] {
                if let authToken = authTokenData["token"] as? String {
                    getUserData(authToken: authToken, completion: { (user, error) in
                        if let user = user {
                            VOYUser.setActiveUser(user: user)
                        }
                        completion(user, error)
                    })
                }else {
                    completion(nil, nil)
                }
            }else if let error = dataResponse.result.error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        
    }
    
    static func getUserData(authToken:String, completion:@escaping(_ user:VOYUser?, _ error:Error?) -> Void) {
        let url = VOYConstant.API.URL + "users/?auth_token=" + authToken
        Alamofire.request(url, method: .get).responseArray { (dataResponse:DataResponse<[VOYUser]>) in
            if let userData = dataResponse.result.value {
                completion(userData.first!,nil)
            }else if let error = dataResponse.result.error {
                print(error.localizedDescription)
                completion(nil,error)
            }
        }
    }
    
}
