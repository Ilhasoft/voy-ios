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
    var repositoryUnderTest: VOYMockReportListRepository!
    
    let themeId: Int = 1234567
    
    override func setUp() {
        viewControllerUnderTest = VOYMockReportListViewController()
        repositoryUnderTest = VOYMockReportListRepository()
        presenterUnderTest = VOYReportListPresenter(view: viewControllerUnderTest, dataSource: repositoryUnderTest)
    }
    
    func testReceivingListCount() {
        let expectations = expectation(description: "Get the a valid list count of each report status")
        let reportStatusList = [VOYReportStatus.approved, VOYReportStatus.notApproved, VOYReportStatus.pendent]
        for status in reportStatusList {
            presenterUnderTest.countReports(themeId: themeId, status: status, mapper: 1)
        }
        XCTAssert(presenterUnderTest.countApprovedReports == 10)
        XCTAssert(presenterUnderTest.countNotApprovedReports == 10)
        XCTAssert(presenterUnderTest.countPendingReports == 10)
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
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
