//
//  VOYCommentTests.swift
//  VoyTests
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYCommentTests: XCTestCase {
    var mockViewController: VOYMockCommentViewController!
    var mockRepository: VOYMockCommentRepository!
    var commentPresenterUnderTest: VOYCommentPresenter!

    var report: VOYReport!

    override func setUp() {
        super.setUp()
        report = VOYReport()
        report.id = 456
        report.name = "That's a report"
        report.comments = 2
        report.description = "This is a description, isn't it?"
        report.shareURL = "shareurl.com.br/report456"

        mockRepository = VOYMockCommentRepository()
        mockViewController = VOYMockCommentViewController()
        commentPresenterUnderTest = VOYCommentPresenter(dataSource: mockRepository, view: mockViewController, report: report)
    }

    // MARK: - Data test

    func testGetComments() {
        let expectations = expectation(description: "Should get 2 comments from the fake reopository")
        commentPresenterUnderTest.onScreenDidLoad()
        DispatchQueue.main.async {
            XCTAssertEqual(self.mockViewController.viewModel!.comments.count, 2)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSaveComments() {
        let expectations = expectation(description: "Should save the comment")
        let commentToSave = VOYComment(text: "Save this!", reportID: self.report.id!)
        commentPresenterUnderTest.save(comment: commentToSave)
        XCTAssertTrue(mockViewController.isShowingProgress)
        DispatchQueue.main.async {
            XCTAssertFalse(self.mockViewController.isShowingProgress)
            XCTAssertTrue(self.mockViewController.hasShownCommentSent)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRemoveComment() {
        let expectations = expectation(description: "Should save the comment")
        commentPresenterUnderTest.onScreenDidLoad()
        DispatchQueue.main.async {
            let commentToRemove = self.mockViewController.viewModel!.comments[0]
            self.commentPresenterUnderTest.remove(commentId: commentToRemove.id)
            DispatchQueue.main.async {
                self.commentPresenterUnderTest.onScreenDidLoad()
                DispatchQueue.main.async {
                    XCTAssertEqual(self.mockViewController.viewModel!.comments.count, 1)
                    expectations.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
