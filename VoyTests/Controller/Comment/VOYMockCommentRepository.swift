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
    func delete(commentId: Int, completion: @escaping (Error?) -> Void) {
    }
    
    func save(comment: VOYComment, completion: @escaping (Error?) -> Void) {
        if !comment.text.isEmpty {
            completion(nil)
        }
    }
}
