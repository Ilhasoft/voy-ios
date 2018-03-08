//
//  VOYLoginRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation

class VOYLoginRepository: VOYLoginDataSource {    

    func login(username: String, password: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        let params = ["username": username, "password": password]
        postRequest(urlSuffix: "get_auth_token/", parameters: params,
             completion: { (authTokenData: [String: Any]?, error) -> Void in
            if let authTokenData = authTokenData {
                if let authToken = authTokenData["token"] as? String {
                    self.getUserData(authToken: authToken, completion: { (user, error) in
                        if let user = user {
                            user.authToken = authToken
                            VOYUser.setActiveUser(user: user)
                        }
                        completion(user, error)
                    })
                } else {
                    completion(nil, nil)
                }
            } else if let error = error {
                completion(nil, error)
            }
        })
    }

    func getUserData(authToken: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        getRequest(urlSuffix: "users/?auth_token=\(authToken)", completion: { (user: VOYUser?, error: Error?) in
            completion(user, error)
        })
    }
}
