//
//  VOYReportDetailTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

//class VOYReportDetailTests: XCTestCase {
//
//    var viewControllerUnderTest: VOYMockReportDetailViewController!
//    var presenterUnderTest: VOYReportDetailPresenter!
//
//    override func setUp() {
//        viewControllerUnderTest = VOYMockReportDetailViewController()
//        let report = VOYReport()
//        presenterUnderTest = VOYReportDetailPresenter(view: viewControllerUnderTest, report: report)
//    }
//
//    func testButtonCommentVisibility() {
//        let expectations = expectation(description: "Test different visibility states for the comment button.")
//        presenterUnderTest.onViewDidLoad()
//        XCTAssertFalse(viewControllerUnderTest.commentButtonIsEnabled)
//        presenterUnderTest.report.status = 1
//        presenterUnderTest.onViewDidLoad()
//        XCTAssert(viewControllerUnderTest.commentButtonIsEnabled)
//        presenterUnderTest.report.status = 2
//        presenterUnderTest.onViewDidLoad()
//        XCTAssertFalse(viewControllerUnderTest.commentButtonIsEnabled)
//        expectations.fulfill()
//        waitForExpectations(timeout: 10, handler: nil)
//    }
//
//    func testNavegation() {
//        let expectations = expectation(description: "Confirm that the app pushed controllers correctly.")
//        presenterUnderTest.onCommentButtonTapped()
//        XCTAssert(viewControllerUnderTest.hasNavigatedToCommentsScreen)
//        presenterUnderTest.report.id = nil
//        presenterUnderTest.onShareButtonTapped()
//        XCTAssertFalse(viewControllerUnderTest.hasSharedText)
//        presenterUnderTest.report.id = 123
//        presenterUnderTest.onShareButtonTapped()
//        XCTAssert(viewControllerUnderTest.hasSharedText)
//        presenterUnderTest.onOptionsButtonTapped()
//        XCTAssert(viewControllerUnderTest.hasShownActionSheet)
//        presenterUnderTest.onTapImage(image: UIImage())
//        XCTAssert(viewControllerUnderTest.hasShownPicture)
//        presenterUnderTest.onTapVideo(videoURL: URL(fileURLWithPath: "www.urlexample.com"))
//        XCTAssert(viewControllerUnderTest.hasShownVideo)
//        presenterUnderTest.onTapEditReport()
//        XCTAssert(viewControllerUnderTest.hasNavigatedToEditReportScreen)
//        expectations.fulfill()
//        waitForExpectations(timeout: 10, handler: nil)
//    }
//}
