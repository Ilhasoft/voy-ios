//
//  VOYAccountRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAccountRepository: VOYAccountDataSource {

    let networkClient = VOYNetworkClient(reachability: VOYDefaultReachability())

    func updateUser(avatar: Int?, password: String?, completion: @escaping(Error?) -> Void) {
        guard let user = VOYUser.activeUser(),
              let authToken = user.authToken,
              let userId = user.id else { return }
        var jsonUser = [String: Any]()
        if let avatar = avatar { jsonUser["avatar"] = avatar }
        if let password = password { jsonUser["password"] = password }

        networkClient.requestDictionary(urlSuffix: "users/\(userId)/",
                                        httpMethod: .put,
                                        parameters: jsonUser,
                                        headers: ["Authorization": "Token " + authToken]) { result, error, _ in
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
