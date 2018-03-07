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
    var viewControllerUnderTest: VOYMockLoginViewController!
    var presenterUnderTest: VOYLoginPresenter!
    let validUsername: String = "pirralho"
    let validPassword: String = "123456"
    let invalidUsername: String = "ohlarrip"
    let invalidPassword: String = "654321"
    
    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockLoginRepository()
        viewControllerUnderTest = VOYMockLoginViewController(redirectedUser: false, presentedAlert: false)
        presenterUnderTest = VOYLoginPresenter(dataSource: VOYMockLoginRepository(), view: viewControllerUnderTest)
    }
    
    override func tearDown() {
        repositoryUnderTest = nil
        viewControllerUnderTest = nil
        presenterUnderTest = nil
        super.tearDown()
    }
    
    // MARK: - Data tests
    func testValidLogin() {
        
        let expectations = expectation(description: "Expecting a VOYUser object not nil")
        repositoryUnderTest.login(username: validUsername, password: validPassword) { (user, error) in
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
    
    // MARK: UITests
    func testRedirectingUser() {
        let expectations = expectation(description: "User will be redirected")
        presenterUnderTest.login(username: validUsername, password: validPassword)
        
        XCTAssertTrue(viewControllerUnderTest.redirectedUser, "User was redirected")
        XCTAssertFalse(viewControllerUnderTest.presentedAlert, "Wrong credential")
        expectations.fulfill()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPresentingErrors() {
        let expectations = expectation(description: "A error alert will be presented")
        presenterUnderTest.login(username: invalidUsername, password: invalidPassword)
        
        XCTAssertTrue(viewControllerUnderTest.presentedAlert, "Wrong credential")
        XCTAssertFalse(viewControllerUnderTest.redirectedUser, "User was redirected")
        expectations.fulfill()
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
