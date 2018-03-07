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
    func testRetrieveThemes() {
        
        var retrievedProjects: Int = 0
        
        let expectations = expectation(description: "Expecting a theme list with one object at least.")
        
        repositoryUnderTest.getMyProjects { (projects, error) in
            for project in projects {
                var params = ["project": project.id as Any, "user": self.userID, "page": 1, "page_size": 50]
                self.repositoryUnderTest.cacheDataFrom(url: self.apiURL, parameters: &params)
                retrievedProjects += 1
            }
            XCTAssert(retrievedProjects == projects.count, "retrieved all projects and saved on cache.")
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
