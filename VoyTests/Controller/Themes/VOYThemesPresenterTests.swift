//
//  VOYThemesPresenterTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 20/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYThemesPresenterTests: XCTestCase {

    private var mockViewController: VOYMockThemesViewController!
    private var mockDataSource: VOYMockThemesDataSource!
    private var presenterUnderTest: VOYThemesPresenter!

    override func setUp() {
        mockViewController = VOYMockThemesViewController()
        mockDataSource = VOYMockThemesDataSource()
        presenterUnderTest = VOYThemesPresenter(dataSource: mockDataSource, view: mockViewController)
    }

    func testThemesSetup() {
        let expectations = expectation(description: "Set the view model in the viewController")
        presenterUnderTest.onReady()
        DispatchQueue.main.async {
            XCTAssertEqual(self.mockViewController.viewModel?.selectedProject?.name, Optional("Project 1"))
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    /**
     * Returns an empty number of themes in the datasource, and makes sure it doesn't keep loading forever
     */
    func testEmptyThemes() {
        let expectations = expectation(description: "Return an empty number of themes")
        mockDataSource.themes = []
        presenterUnderTest.onReady()
        DispatchQueue.main.async {
            XCTAssertFalse(self.mockViewController.isShowingProgress)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testRoutes() {
        XCTAssertFalse(mockViewController.hasRedirectedToProfileScreen)
        XCTAssertFalse(mockViewController.hasRedirectedToReportsScreen)

        presenterUnderTest.onProfileAction()
        XCTAssertTrue(mockViewController.hasRedirectedToProfileScreen)

        let theme = VOYTheme()
        theme.id = 30
        presenterUnderTest.onThemeSelected(theme: theme)
        XCTAssertEqual(VOYTheme.activeTheme()?.id, Optional(30))
        XCTAssertTrue(mockViewController.hasRedirectedToReportsScreen)
    }

    func testUserDataUpdated() {
        XCTAssertFalse(mockViewController.hasUpdatedUserData)
        presenterUnderTest.onUserDataUpdated()
        XCTAssertTrue(mockViewController.hasUpdatedUserData)
    }

    func testNotifications() {
        XCTAssertFalse(mockViewController.badgeIsVisible)

        let report = VOYReport()
        report.id = 89
        let notification = VOYNotification(body: "Your report needs improvement", report: report)
        mockDataSource.notifications = [notification]

        presenterUnderTest.onViewDidAppear()
        XCTAssertTrue(mockViewController.badgeIsVisible)

        mockDataSource.notifications = []
        presenterUnderTest.onViewDidAppear()
        XCTAssertFalse(mockViewController.badgeIsVisible)

        XCTAssertFalse(mockViewController.hasToggledNotification)
        presenterUnderTest.onNotificationsAction()
        XCTAssertTrue(mockViewController.hasToggledNotification)
    }

    func testSelectingNewProject() {
        let expectations = expectation(description: "Change the selected project")
        presenterUnderTest.onReady()
        DispatchQueue.main.async {
            self.presenterUnderTest.onProjectSelectionChanged(project: "Project 2")
            XCTAssertEqual(self.mockViewController.viewModel?.selectedProject?.name, Optional("Project 2"))
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}