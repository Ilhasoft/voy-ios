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
    
    var themeListUnderTest: VOYMockThemeListRepository!
    var apiURL: String = "www.apiurl.com/hadfkadjfsadafdsasssk"
    var userID: String = "userid9dfs9df9sd"
    
    override func setUp() {
        super.setUp()
        themeListUnderTest = VOYMockThemeListRepository()
    }
    
    override func tearDown() {
        themeListUnderTest = nil
        super.tearDown()
    }
    
    func testRetrieveThemes() {
        
        var retrievedProjects: Int = 0
        
        let expectations = expectation(description: "Expecting a theme list with one object at least.")
        
        themeListUnderTest.getMyProjects { (projects, error) in
            for project in projects {
                var params = ["project": project.id as Any, "user": self.userID, "page": 1, "page_size": 50]
                self.themeListUnderTest.cacheDataFrom(url: self.apiURL, parameters: &params)
                retrievedProjects += 1
            }
            XCTAssert(retrievedProjects == projects.count, "retrieved all projects and saved on cache.")
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
