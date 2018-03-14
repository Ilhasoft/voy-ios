//
//  VOYReportDetailTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYReportDetailTests: XCTestCase {

    var viewControllerUnderTest: VOYMockReportDetailViewController!
    var presenterUnderTest: VOYReportDetailPresenter!

    override func setUp() {
        viewControllerUnderTest = VOYMockReportDetailViewController()
        let report = VOYReport()
        presenterUnderTest = VOYReportDetailPresenter(view: viewControllerUnderTest, report: report)
    }

    func testPresenterFlow() {
        let expectations = expectation(description: "Test the normal flow of the report presenter")
        expectations.fulfill()
        presenterUnderTest.onCommentButtonTapped()
        XCTAssertTrue(viewControllerUnderTest.hasNavigatedToCommentsScreen)
        waitForExpectations(timeout: 10, handler: nil)
    }

}
