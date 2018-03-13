//
//  VOYUserTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 13/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYUserTests: XCTestCase {
    
    var userUnderTest: VOYUser!
    
    override func setUp() {
        userUnderTest = VOYUser()
        userUnderTest.id = 10
    }

    func testSetActiveUser() {
        let expectations = expectation(description: "Test set the active user.")
        VOYUser.setActiveUser(user: userUnderTest)

        XCTAssertTrue(VOYUser.activeUser()!.id == userUnderTest.id, "Active user works correctly")
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testDeactiveUser() {
        let expectations = expectation(description: "Test remove active user.")
        VOYUser.setActiveUser(user: userUnderTest)
        VOYUser.deactiveUser()

        XCTAssertTrue(VOYUser.activeUser() == nil, "Active user removed correctly")
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testParseUser() {
        let expectations = expectation(description: "Test user is being parsed correctly.")
        let map: [String: Any] = [
            "id": 10
        ]
        let parsedUser = VOYUser(JSON: map)
        XCTAssertNotNil(parsedUser)
        XCTAssertEqual(parsedUser!.id, 10)
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }

}
