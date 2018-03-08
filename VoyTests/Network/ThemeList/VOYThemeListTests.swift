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
    var presenterUnderTest: VOYMockThemeListPresenter!
    var apiURL: String = "www.apiurl.com/hadfkadjfsadafdsasssk"
    var userID: String = "userid9dfs9df9sd"
    
    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockThemeListRepository()
        viewControllerUnderTest = VOYMockThemeListViewController()
    }
    
    override func tearDown() {
        repositoryUnderTest = nil
        viewControllerUnderTest = nil
        presenterUnderTest = nil
        super.tearDown()
    }
    
    // MARK: - Data tests
    func testRetrieveThemesWithNetwork() {
        repositoryUnderTest.setNetwork(hasNetwork: true)
        var retrievedProjects: Int = 0
        let expectations = expectation(description: "Expecting a theme list with one object at least.")
        repositoryUnderTest.getMyProjects { (projects, _) in
            for project in projects {
                var params = ["project": project.id as Any, "user": self.userID, "page": 1, "page_size": 50]
                self.repositoryUnderTest.cacheDataFrom(url: self.apiURL, parameters: &params)
                retrievedProjects += 1
            }
            XCTAssert(retrievedProjects == projects.count, "retrieved all projects.")
            XCTAssert(projects.count == self.repositoryUnderTest.retrievedProjects, "Saved all projects")
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRetrieveThemesWithoutNetwork() {
        repositoryUnderTest.setNetwork(hasNetwork: false)
        var retrievedProjects: Int = 0
        let expectations = expectation(description: "Expecting a empty theme list.")
        repositoryUnderTest.getMyProjects { (projects, _) in
            for project in projects {
                var params = ["project": project.id as Any, "user": self.userID, "page": 1, "page_size": 50]
                self.repositoryUnderTest.cacheDataFrom(url: self.apiURL, parameters: &params)
                retrievedProjects += 1
            }
            XCTAssert(retrievedProjects == 0, "Couldn't retrieve the list.")
            XCTAssert(self.repositoryUnderTest.retrievedProjects == 0, "Don't have connection nor cached data.")
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - UITests
    func testDefaultControllerFlow() {
        let expectations = expectation(description: "Validate the whole controller behaviour flow.")
        viewControllerUnderTest.getProjects()
        XCTAssertTrue(viewControllerUnderTest.startedPresenter, "Started loading projects.")
        XCTAssertTrue(viewControllerUnderTest.listWasUpdated, "Updated project list.")
        XCTAssertTrue(viewControllerUnderTest.cachedList, "Stored list on cache.")
        XCTAssertTrue(viewControllerUnderTest.dropDownWasSet, "Loaded dropdown menu.")
        XCTAssertTrue(viewControllerUnderTest.loadedThemesfromProject, "Loaded themes relative to the current project.")
        XCTAssertTrue(viewControllerUnderTest.tableViewWasUpdated, "Updated list of themes on tableView.")
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
