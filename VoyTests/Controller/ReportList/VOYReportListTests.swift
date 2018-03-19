//
//  VOYReportListTest.swift
//  VoyTests
//
//  Created by Dielson Sales on 12/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYReportListTests: XCTestCase {
    var viewControllerUnderTest: VOYMockReportListViewController!
    var presenterUnderTest: VOYReportListPresenter!
    
    override func setUp() {
        viewControllerUnderTest = VOYMockReportListViewController()
    }
    
    func testTapOnReport() {
        // TODO
//        let expectations = expectation(description: "Check if the controller is telling the view to redirect correctly.")
//        let report = [
//            "id": 20
//        ]
//        presenterUnderTest.onReportSelected(object: report)
//        XCTAssertTrue(viewControllerUnderTest.hasNavigatedToReportDetails, "View redirected to report details correctly")
//        expectations.fulfill()
//        waitForExpectations(timeout: 10, handler: nil)
    }
}
