//
//  VOYCommentRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation

class VOYCommentRepository: VOYCommentDataSource {
    
    let networkClient = VOYNetworkClient()

    func save(comment: VOYComment, completion: @escaping (Error?) -> Void) {

        let authToken = VOYUser.activeUser()!.authToken!
        let headers = ["Authorization": "Token " + authToken, "Content-Type": "application/json"]
        networkClient.requestDictionary(urlSuffix: "report-comments/",
                                   httpMethod: .post,
                                   parameters: comment.toJSON(),
                                   headers: headers) { value, error, _ in
            completion(error)
        }
    }
}
