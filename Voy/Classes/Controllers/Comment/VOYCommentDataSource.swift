//
//  VOYCommentDataSource.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYCommentDataSource {
    func save(comment: VOYComment, completion:@escaping (Error?) -> Void)
    func delete(commentId: Int, completion: @escaping (Error?) -> Void)
}
