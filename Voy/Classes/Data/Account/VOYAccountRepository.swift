//
//  VOYAccountRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAccountRepository: VOYAccountDataSource {

    let networkClient = VOYNetworkClient()

    func updateUser(avatar: Int?, password: String?, completion: @escaping(Error?) -> Void) {
        let user = VOYUser.activeUser()!
        var jsonUser = [String: Any]()
        let authToken = user.authToken!
        if let avatar = avatar {
            jsonUser["avatar"] = avatar
        }
        if let password = password {
            jsonUser["password"] = password
        }
        let headers = ["Authorization": "Token " + authToken, "Content-Type": "application/json"]

        networkClient.requestDictionary(urlSuffix: "users/\(user.id!)/",
                                        httpMethod: .put,
                                        parameters: jsonUser,
                                        headers: headers) { result, error in
            if result != nil {
                let loginRepository = VOYLoginRepository()
                loginRepository.getUserData(authToken: user.authToken, completion: { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let u = user {
                        u.authToken = authToken
                        VOYUser.setActiveUser(user: u)
                        NotificationCenter.default.post(name: NSNotification.Name("userDataUpdated"), object: nil)
                    }
                })
                completion(nil)
            } else if let error = error {
                print(error.localizedDescription)
                completion(error)
            }
        }
    }
}
