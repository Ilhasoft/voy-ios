//
//  VOYMockCommentRepository.swift
//  Voy
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYMockCommentRepository: VOYCommentDataSource {

    var comments: [VOYComment] = []

    init() {
        let user = VOYUser()
        user.id = 1
        user.email = "john.snow@winterfell.com"
        user.username = "johnsnow"
        user.first_name = "John"
        user.password = "123456"

        let comment1 = VOYComment(text: "Comment 1", reportID: 10)
        comment1.id = 30
        comment1.createdBy = user

        let comment2 = VOYComment(text: "Comment 2", reportID: 11)
        comment2.id = 31
        comment2.createdBy = user

        comments = [comment1, comment2]
    }

    func getComments(for report: VOYReport, completion: @escaping ([VOYComment]) -> Void) {
        DispatchQueue.main.async {
            completion(self.comments)
        }
    }

    func save(comment: VOYComment, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            completion(nil)
        }
    }

    func delete(commentId: Int, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            for (index, comment) in self.comments.enumerated() {
                if comment.id! == commentId {
                    self.comments.remove(at: index)
                    break
                }
            }
            completion(nil)
        }
    }

    func getImage(for comment: VOYComment, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.async {
            completion(UIImage())
        }
    }
}
