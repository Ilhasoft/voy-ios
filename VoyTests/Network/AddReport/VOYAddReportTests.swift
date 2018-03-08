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

    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockAddReportRepository()
    }
    
    override func tearDown() {
        repositoryUnderTest = nil
        super.tearDown()
    }
    
    // MARK: - Data tests
    func testSaveReportOnline() {
        let expectations = expectation(description: "Successful report upload!")
        repositoryUnderTest.setNetwork(hasNetwork: true)
        let newReport = VOYReport()
        newReport.id = 123456
        newReport.name = "New Report"
        newReport.removedMedias = [VOYMedia(), VOYMedia()]
        let cameraData = VOYCameraData(image: UIImage(), thumbnail: UIImage(), thumbnailPath: URL(fileURLWithPath:""), path: URL(fileURLWithPath:""), type: .image)
        newReport.cameraDataList = [cameraData, cameraData, cameraData]
        repositoryUnderTest.save(report: newReport) { (error, reportID) in
            XCTAssertNil(error, "Got no errors.")
            XCTAssertNotNil(reportID, "Valid report id.")
            XCTAssertTrue(VOYMockMediaFileRepository.shared.removedFile, "Cleaned removed medias array.")
            XCTAssertTrue(VOYMockMediaFileRepository.shared.uploadedFile, "Upload camera data list array.")
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
        let attachControllerUnderTest: VOYMockAddReportAttachViewController = VOYMockAddReportAttachViewController()
        let tagsControllerUnderTest: VOYMockAddReportTagsViewController = VOYMockAddReportTagsViewController()
        let presenterUnderTest: VOYAddReportTagsPresenter = VOYAddReportTagsPresenter(dataSource: VOYMockAddReportRepository(), view: tagsControllerUnderTest)
        // Emulating media button tap
        attachControllerUnderTest.buttonDidTap(actionSheetViewController: VOYActionSheetViewController(), button: UIButton(), index: 0)
        
        tagsControllerUnderTest.presenter = presenterUnderTest
        // Emulating a - Send Report - Event
        tagsControllerUnderTest.save()
        
        XCTAssertTrue(attachControllerUnderTest.addedNextButton, "Added button on navbar.")
        XCTAssertTrue(attachControllerUnderTest.loadedMediaFromPreviousReport, "loaded medias from previous report.")
        XCTAssertTrue(attachControllerUnderTest.addedMedias, "Added medias on the new report.")
        XCTAssertTrue(attachControllerUnderTest.startedMediaPicker, "Presented a UIImagePickerController.")
        XCTAssertTrue(tagsControllerUnderTest.loadedTags, "Loaded tags for this")
        XCTAssertTrue(tagsControllerUnderTest.updatedSelectedTags, "")
        XCTAssertTrue(tagsControllerUnderTest.userTappedSave, "")
        XCTAssertTrue(tagsControllerUnderTest.startedAnimation, "")
        XCTAssertTrue(tagsControllerUnderTest.stopedAnimation, "")
        XCTAssertTrue(tagsControllerUnderTest.showedSuccess, "")
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
