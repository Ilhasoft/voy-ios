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
    var presenterUnderTest: VOYAccountPresenter!
    var viewControllerUnderTest: VOYMockAccountViewController!

    let newPassword: String = "NewPassword"
    let newAvatar: Int = 000000
    
    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockAccountRepository()
        viewControllerUnderTest = VOYMockAccountViewController()
        presenterUnderTest = VOYAccountPresenter(dataSource: repositoryUnderTest, view: viewControllerUnderTest)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUpdateUser() {
        let expectations = expectation(description: "Get no errors")
        presenterUnderTest.updateUser(avatar: newAvatar, password: newPassword)
        XCTAssert(viewControllerUnderTest.enabledDisabledLoading == 2)
        XCTAssert(viewControllerUnderTest.didSaveAccount)
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLogout() {
        let expectations = expectation(description: "Unactivated user")
        viewControllerUnderTest.btLogoutTapped()
        presenterUnderTest.logoutUser()
        XCTAssert(viewControllerUnderTest.userTappedLogout)
        expectations.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
