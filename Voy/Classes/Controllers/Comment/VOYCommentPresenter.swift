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
    private var comments: [VOYComment] = []

    init(dataSource: VOYCommentDataSource, view: VOYCommentContract, report: VOYReport) {
        self.dataSource = dataSource
        self.view = view
        self.report = report
    }

    func onScreenDidLoad() {
        getComments(for: report)
    }

    private func getComments(for report: VOYReport) {
        view?.showProgress()
        dataSource.getComments(for: report) { comments in
            self.view?.hideProgress()
            self.comments = comments
            let viewModel = VOYCommentViewModel(comments: comments)
            self.view?.update(with: viewModel)
        }
    }

    func save(comment: VOYComment) {
        view?.showProgress()
        dataSource.save(comment: comment) { (error) in
            self.view?.hideProgress()
            self.view?.showCommentSentAlert()
            if let error = error {
                print(error)
            }
        }
    }

    func remove(commentId: Int) {
        view?.showProgress()
        dataSource.delete(commentId: commentId) { _ in
            self.getComments(for: self.report)
        }
    }

    func getImageForComment(at position: Int) {
        guard position < comments.count else { return }
        let comment = comments[position]
        dataSource.getImage(for: comment) { imageOptional in
            if let image = imageOptional {
                self.view?.setImage(image: image, at: position)
            }
        }

    }
}
