//
//  VOYAddReportTests.swift
//  VoyTests
//
//  Created by Pericles Jr on 07/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYAddReportTests: XCTestCase {
    var repositoryUnderTest: VOYMockAddReportRepository!
    var controllerUnderTest: VOYMockAddReportTagsViewController!

    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockAddReportRepository()
        controllerUnderTest = VOYMockAddReportTagsViewController()
    }
    
    override func tearDown() {
        repositoryUnderTest = nil
        super.tearDown()
    }
    
    // MARK: - Data tests
    func testSaveReportOnline() {
        let expectations = expectation(description: "Successful report upload!")
        repositoryUnderTest.setNetwork(hasNetwork: true)
        repositoryUnderTest.save(report: VOYReport()) { (error, reportID) in
            XCTAssertNil(error, "Got no errors.")
            XCTAssertNotNil(reportID, "Valid report id.")
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSaveReportOffline() {
        let expectations = expectation(description: "Successful local save!")
        repositoryUnderTest.setNetwork(hasNetwork: false)
        repositoryUnderTest.save(report: VOYReport()) { (error, reportID) in
            XCTAssertNil(error)
            XCTAssertNil(reportID)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - UITests
    func testDefaultControllerFlow() {
        let expectations = expectation(description: "Entered all methods that handles the UI.")
        let controllerUnderTest: VOYMockAddReportTagsViewController = VOYMockAddReportTagsViewController()
        let presenterUnderTest: VOYAddReportTagsPresenter = VOYAddReportTagsPresenter(
            dataSource: VOYMockAddReportRepository(),
            view: controllerUnderTest
        )
        controllerUnderTest.presenter = presenterUnderTest
        // Emulating a - Send Report - Event
        controllerUnderTest.save()
        XCTAssertTrue(controllerUnderTest.loadedTags, "Loaded tags for this")
        XCTAssertTrue(controllerUnderTest.updatedSelectedTags, "")
        XCTAssertTrue(controllerUnderTest.userTapedSave, "")
        XCTAssertTrue(controllerUnderTest.startedAnimation, "")
        XCTAssertTrue(controllerUnderTest.stopedAnimation, "")
        XCTAssertTrue(controllerUnderTest.showedSuccess, "")
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
