//
//  VOYCommentRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation

class VOYCommentRepository: VOYCommentDataSource {

    var authToken: String {
        return VOYUser.activeUser()?.authToken ?? ""
    }

    let networkClient = VOYNetworkClient(reachability: VOYDefaultReachability())

    func save(comment: VOYComment, completion: @escaping (Error?) -> Void) {

        let headers = ["Authorization": "Token " + authToken]
        networkClient.requestDictionary(urlSuffix: "report-comments/",
                                   httpMethod: .post,
                                   parameters: comment.toJSON(),
                                   headers: headers) { _, error, _ in
            completion(error)
        }
    }

    func delete(commentId: Int, completion: @escaping (Error?) -> Void) {
        networkClient.requestDictionary(urlSuffix: "report-comments/\(commentId)/",
                                    httpMethod: .delete,
                                    headers: ["Authorization": "Token " + authToken]) { (_, error, _)  in
            completion(error)
        }
    }
}
