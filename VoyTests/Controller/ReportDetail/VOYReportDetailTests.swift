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

    var report: VOYReport!
    var mockviewController: VOYMockReportDetailViewController!
    var presenterUnderTest: VOYReportDetailsPresenter!

    override func setUp() {
        mockviewController = VOYMockReportDetailViewController()
        report = VOYReport()
        report.name = "Report 1"
        report.description = "Description of the report"
        report.tags = ["tag1", "tag2"]
        report.urls = []
        report.comments = 0
        report.created_on = "2018-04-19T13:55:19.325543Z"
        presenterUnderTest = VOYReportDetailsPresenter(report: report, view: mockviewController)
    }

    func testButtonCommentVisibility() {
        let currentUser = VOYUser()
        currentUser.avatar = "www.google.com"
        VOYUser.setActiveUser(user: currentUser)

        let activeTheme = VOYTheme()
        activeTheme.color = "ffffff"
        VOYTheme.setActiveTheme(theme: activeTheme)

        presenterUnderTest.onViewDidLoad()
        XCTAssertFalse(mockviewController.commentButtonIsEnabled)

        report.status = VOYReportStatus.approved.rawValue
        presenterUnderTest.onViewDidLoad()
        XCTAssertTrue(mockviewController.commentButtonIsEnabled)

        report.status = VOYReportStatus.pendent.rawValue
        presenterUnderTest.onViewDidLoad()
        XCTAssertFalse(mockviewController.commentButtonIsEnabled)

        report.status = VOYReportStatus.notApproved.rawValue
        presenterUnderTest.onViewDidLoad()
        XCTAssertFalse(mockviewController.commentButtonIsEnabled)
    }

    func testNavegation() {
        presenterUnderTest.onTapCommentsButton()
        XCTAssert(mockviewController.hasNavigatedToCommentsScreen)

        presenterUnderTest.onTapSharedButton()
        XCTAssertFalse(mockviewController.hasSharedText)

        report.shareURL = "http://voy-dev.ilhasoft.mobi/project/world%20map/report/2293"
        presenterUnderTest.onTapSharedButton()
        XCTAssertTrue(mockviewController.hasSharedText)

        presenterUnderTest.onTapOptionsButton()
        XCTAssertTrue(mockviewController.hasShownActionSheet)

        presenterUnderTest.onTapImage(image: UIImage())
        XCTAssertTrue(mockviewController.hasShownPicture)

        presenterUnderTest.onTapVideo(videoURL: URL(fileURLWithPath: "www.urlexample.com"))
        XCTAssertTrue(mockviewController.hasShownVideo)

        presenterUnderTest.onTapEditReport()
        XCTAssertTrue(mockviewController.hasNavigatedToEditReportScreen)

        presenterUnderTest.onSelectURL(URL(fileURLWithPath: "www.urlexample.com"))
        XCTAssertTrue(mockviewController.hasOpenedURL)
    }

    /**
     * Issues alert are supposed to check if there is an issue.
     */
    func testReportIssues() {
        report.lastNotification = nil
        presenterUnderTest.onTapIssueButton()
        XCTAssertFalse(mockviewController.hasShownIssueAlert)

        report.lastNotification = "Something's wrong with the report"
        presenterUnderTest.onTapIssueButton()
        XCTAssertTrue(mockviewController.hasShownIssueAlert)
    }
}
