//
//  VOYThemeListTests.swift
//  VoyTests
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYThemeListTests: XCTestCase {
    var repositoryUnderTest: VOYMockThemeListRepository!
    var viewControllerUnderTest: VOYMockThemeListViewController!
    var presenterUnderTest: VOYThemeListPresenter!
    var reachability = VOYMockReachability()
    
    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockThemeListRepository(reachability: reachability)
        viewControllerUnderTest = VOYMockThemeListViewController()
        presenterUnderTest = VOYThemeListPresenter(
            view: viewControllerUnderTest,
            dataSource: repositoryUnderTest,
            userJustLogged: true
        )
    }

    override func tearDown() {
        repositoryUnderTest = nil
        viewControllerUnderTest = nil
        presenterUnderTest = nil
        super.tearDown()
    }

    func testRetrieveProjects() {
        let expectations = expectation(description: "Validate the whole controller behaviour flow.")
        reachability.mockNetworkAvailable = false
        presenterUnderTest.onViewDidLoad()
        XCTAssertTrue(presenterUnderTest.projects.count == 0, "Number of projects retrieved are true")
        XCTAssertTrue(viewControllerUnderTest.listCount == 0, "Updated project list.")
        XCTAssertTrue(repositoryUnderTest.cachedProjectsCount == 0, "No projects cached")
        reachability.mockNetworkAvailable = true
        presenterUnderTest.onViewDidLoad()
        XCTAssertTrue(presenterUnderTest.projects.count == 5, "Number of projects retrieved are true")
        XCTAssertTrue(viewControllerUnderTest.listCount == 5, "Updated project list.")
        XCTAssertTrue(repositoryUnderTest.cachedProjectsCount == 5, "Cached all projects")
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testTapOnTheme() {
        let expectations = expectation(
            description: "Check if the presenter actually instructs the view to navigate when tapping on a theme."
        )
        reachability.mockNetworkAvailable = true
        presenterUnderTest.onViewDidLoad()
        let themeObj: [String: Any] = [
            "id": 37,
            "project": "project",
            "bounds": [1.0, 1.0],
            "name": "name",
            "description": "description",
            "tags": ["tag1", "tag2"],
            "color": "color",
            "pin": "pin",
            "reports_count": 2,
            "created_on": "01-02-2018",
            "allow_links": true
        ]
        presenterUnderTest.onThemeSelected(object: themeObj)
        XCTAssertTrue(viewControllerUnderTest.hasNavigatedToReportList, "Successfully redirected to report screen")
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUpdateNotifications() {
        let expectations = expectation(description: "Get notification and set badged as visible.")
        presenterUnderTest.updateNotifications()
        XCTAssert(repositoryUnderTest.notificationList.count == 3)
        XCTAssertFalse(viewControllerUnderTest.badgeView.isHidden)
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
