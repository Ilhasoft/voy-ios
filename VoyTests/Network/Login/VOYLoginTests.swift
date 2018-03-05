//
//  VOYLoginTests.swift
//  VoyTests
//
//  Created by Pericles Jr on 01/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYLoginTests: XCTestCase {
    
    var repositoryUnderTest: VOYMockLoginRepository!
    
    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockLoginRepository()
    }
    
    override func tearDown() {
        repositoryUnderTest = nil
        
        super.tearDown()
    }
    
    func testValidLogin() {
        
        let expectations = expectation(description: "Expecting a VOYUser object not nil")
        repositoryUnderTest.login(username: "pirralho", password: "123456") { (user, error) in
            XCTAssertNotNil(user, "Retrieved user data")
            XCTAssertNil(error, "Got no errors")
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInvalidLogin() {
        let expectations = expectation(description: "Expecting a nil value.")
        repositoryUnderTest.login(username: "username", password: "invalidPassword") { (user, error) in
            XCTAssertNil(user, "Nil user")
            XCTAssertNil(error, "Returned error")
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
