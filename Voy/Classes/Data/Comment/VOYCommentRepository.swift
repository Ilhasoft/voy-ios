//
//  VOYCommentRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYCommentRepository: VOYCommentDataSource {

    var authToken: String {
        return VOYUser.activeUser()?.authToken ?? ""
    }

    let networkClient = VOYNetworkClient(reachability: VOYDefaultReachability())

    func getComments(for report: VOYReport, completion: @escaping ([VOYComment]) -> Void) {
        guard let reportId = report.id else {
            completion([])
            return
        }
        networkClient.requestObjectArray(urlSuffix: "report-comments/?report=\(reportId)",
                                         httpMethod: .get) { (comments: [VOYComment]?, _) in
            if let comments = comments {
                completion(comments)
            } else {
                completion([])
            }
        }
    }

    func save(comment: VOYComment, completion: @escaping (Error?) -> Void) {
        networkClient.requestDictionary(urlSuffix: "report-comments/",
                                        httpMethod: .post,
                                        parameters: comment.toJSON(),
                                        headers: ["Authorization": "Token " + authToken]) { _, error, _ in
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

    func getImage(for comment: VOYComment, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = comment.createdBy.avatar else {
            completion(nil)
            return
        }
        networkClient.requestImage(url: imageURL) { image, _ in
            completion(image)
        }
    }
}
