//  VOYMockLoginRepository.swift
//  VoyTests
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.

import XCTest
@testable import Voy

enum TokenStatus: String {
    case validToken
    case invalidToken
}

class VOYMockLoginRepository: VOYLoginDataSource {

    let user: VOYUser = VOYUser()
    static let validUsername = "johnsnow"
    static let validPassword = "123456"

    func login(username: String, password: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        if username == VOYMockLoginRepository.validUsername && password == VOYMockLoginRepository.validPassword {
            getUserData(authToken: TokenStatus.validToken.rawValue, completion: { (user, _) in
                if let user = user {
                    completion(user, nil)
                } else {
                    completion(nil, nil)
                }
            })
        } else {
            // This means wrong username or password
            completion(nil, nil)
        }
    }

    func getUserData(authToken: String, completion: @escaping (VOYUser?, Error?) -> Void) {
        if authToken == TokenStatus.validToken.rawValue {
            self.user.authToken = authToken
            self.user.avatar = "Avatar"
            self.user.first_name = "John"
            self.user.email = "johnsnow@winterfell.com"
            completion(user, nil)
        } else {
            completion(nil, nil)
        }
    }
}
