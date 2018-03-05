//
//  VOYMockCommentRepository.swift
//  Voy
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYMockCommentRepository: VOYCommentDataSource {
    func save(comment: VOYComment, completion: @escaping (Error?) -> Void) {
        if !comment.text.isEmpty {
            completion(nil)
        }
    }
}
