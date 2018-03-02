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
    
    var interactorUnderTest: MockVOYProjectInteractor!
    
    override func setUp() {
        super.setUp()
        interactorUnderTest = MockVOYProjectInteractor()
    }
    
    override func tearDown() {
        interactorUnderTest = nil
        super.tearDown()
    }
    
    func testRetrieveThemes() {
        let expectations = expectation(description: "Expecting valid theme list return")
        interactorUnderTest.getMyProjects { (themeList, <#Error?#>) in
            XCTAssertNotNil(themeList, "Returned a theme list")
        }
//        interactorUnderTest.login(username: "username", password: "invalidPassword") { (user, error) in
//            XCTAssertNil(user, "Nil user")
//            XCTAssertNil(error, "Returned error")
//            expectations.fulfill()
//        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
