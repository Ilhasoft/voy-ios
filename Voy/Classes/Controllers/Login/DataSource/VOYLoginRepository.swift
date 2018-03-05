//
//  VOYLoginRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Alamofire

class VOYLoginRepository: VOYLoginDataSource {    

    func login(username: String, password: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        let params = ["username":username,"password":password]
        
        Alamofire.request(VOYConstant.API.URL + "get_auth_token/", method: .post, parameters: params).responseJSON { (dataResponse:DataResponse<Any>) in
            if let authTokenData = dataResponse.result.value as? [String:Any] {
                if let authToken = authTokenData["token"] as? String {
                    self.getUserData(authToken: authToken, completion: { (user, error) in
                        if let user = user {
                            user.authToken = authToken
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
    
    func getUserData(authToken: String, completion: @escaping (VOYUser?, Error?) -> Void) {
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
