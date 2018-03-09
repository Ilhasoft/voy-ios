//
//  VOYLoginRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation

class VOYLoginRepository: VOYLoginDataSource {
    
    var networkClient = VOYNetworkClient()

    func login(username: String, password: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        let params = ["username": username, "password": password]
        networkClient.requestDictionary(urlSuffix: "get_auth_token/",
                                        httpMethod: .post,
                                        parameters: params) { (authTokenData: [String: Any]?, error, _) in
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
        }
    }

    func getUserData(authToken: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        networkClient.requestObjectArray(urlSuffix: "users/?auth_token=\(authToken)",
                                   httpMethod: .get) { (userList: [VOYUser]?, error, _) in
            if let userList = userList, userList.count > 0 {
                completion(userList.first!, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
