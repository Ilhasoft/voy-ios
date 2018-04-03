//
//  VOYCommentPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYCommentPresenter {

    weak var view: VOYCommentContract?
    var dataSource: VOYCommentDataSource

    init(dataSource: VOYCommentDataSource, view: VOYCommentContract) {
        self.dataSource = dataSource
        self.view = view
    }

    func save(comment: VOYComment, completion:@escaping (Error?) -> Void) {
        dataSource.save(comment: comment) { (error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func remove(commentId: Int, completion: @escaping (_ error: Error?) -> Void) {
        dataSource.delete(commentId: commentId) { (error) in
            completion(error)
        }
    }
}
