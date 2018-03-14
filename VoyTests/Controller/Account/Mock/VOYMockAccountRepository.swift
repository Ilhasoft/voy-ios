//
//  VOYMockAccountRepository.swift
//  Voy
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYMockAccountRepository: VOYAccountDataSource {
    
    func updateUser(avatar: Int?, password: String?, completion: @escaping (Error?) -> Void) {
        let oldAvatar = "OldAvatar"
        let oldPassword = "OldPassword"

        let user = VOYUser()
        user.authToken = "TokenExample"
        user.avatar = oldAvatar
        user.password = oldPassword
        
        user.password = password
        user.avatar = String(describing: avatar)
        
        if user.password != oldPassword, user.avatar != oldAvatar {
            completion(nil)
        } else {
            completion(NSError.init() as Error)
        }
    }
    
}
