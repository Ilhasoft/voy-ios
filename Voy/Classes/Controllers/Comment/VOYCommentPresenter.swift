//
//  VOYCommentPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYCommentPresenter {

    private weak var view: VOYCommentContract?
    private var dataSource: VOYCommentDataSource
    private var report: VOYReport

    init(dataSource: VOYCommentDataSource, view: VOYCommentContract, report: VOYReport) {
        self.dataSource = dataSource
        self.view = view
        self.report = report
    }

    func onScreenDidLoad() {
        getComments(for: report)
    }

    private func getComments(for report: VOYReport) {
        dataSource.getComments(for: report) { comments in
            let viewModel = VOYCommentViewModel(comments: comments)
            self.view?.update(with: viewModel)
        }
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
