//
//  VOYAccountListTests.swift
//  VoyTests
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYAccountListTests: XCTestCase {
    
    var repositoryUnderTest: VOYMockAccountRepository!
    
    let newPassword: String = "NewPassword"
    let newAvatar: Int = 000000
    
    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockAccountRepository()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUpdateUser() {
        let expectations = expectation(description: "Get no errors")
        repositoryUnderTest.updateUser(avatar: newAvatar, password: newPassword) { (error) in
            XCTAssertNil(error)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
