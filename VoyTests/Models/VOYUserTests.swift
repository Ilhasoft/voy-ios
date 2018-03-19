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
    
    func testOk() {
        XCTAssertEqual("String", "String")
    }

    func testSetActiveUser() {
        VOYUser.setActiveUser(user: userUnderTest)
        XCTAssertTrue(VOYUser.activeUser()!.id == userUnderTest.id)
    }

    func testDeactiveUser() {
        VOYUser.setActiveUser(user: userUnderTest)
        VOYUser.deactiveUser()
        XCTAssertTrue(VOYUser.activeUser() == nil)
    }

    func testParseUser() {
        let map: [String: Any] = [
            "id": 10
        ]
        let parsedUser = VOYUser(JSON: map)
        XCTAssertNotNil(parsedUser)
        XCTAssertEqual(parsedUser!.id, 10)
    }
}
