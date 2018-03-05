//
//  VOYMockLoginRepository.swift
//  VoyTests
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

enum TokenStatus: String {
    case validToken = "validToken"
    case invalidToken = "invalidToken"
}

class VOYMockLoginRepository: VOYLoginDataSource {
    
    let user: VOYUser = VOYUser()
    let validUsername = "pirralho"
    let validPassword = "123456"
    
    func login(username: String, password: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        if username == validUsername, password == validPassword {
            getUserData(authToken: TokenStatus.validToken.rawValue, completion: { (user, error) in
                if let user = user {
                    completion(user, nil)
                } else {
                    completion(nil, nil)
                }
            })
        } else {
            completion(nil, nil)
        }
    }
    
    func getUserData(authToken: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        if authToken == TokenStatus.validToken.rawValue {
            self.user.authToken = authToken
            self.user.avatar = "Avatar"
            self.user.first_name = "firstName"
            self.user.email = "user@user.com"
            completion(user, nil)
        } else {
            completion(nil, nil)
        }
    } 
}
