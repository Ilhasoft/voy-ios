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
        
//        let expectations = expectation(description: "Expecting a JSON data not nil")
//        interactorUnderTest.login(username: "pirralho", password: "123456") { (user, error) in
//            XCTAssertNil(error, "No errors")
//            XCTAssertNotNil(user, "Retrived user")
//            expectations.fulfill()
//        }
//        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInvalidLogin() {
//        let expectations = expectation(description: "Expecting a JSON data not nil")
//        interactorUnderTest.login(username: "username", password: "invalidPassword") { (user, error) in
//            XCTAssertNil(user, "Nil user")
//            XCTAssertNil(error, "Returned error")
//            expectations.fulfill()
//        }
//        waitForExpectations(timeout: 10, handler: nil)
    }
    
//    func testValidTokenRequest() {
//        let expectations = expectation(description: "Expecting a JSON data not nil")
//        interactorUnderTest.login(username: "pirralho", password: "123456") { (user, error) in
//            XCTAssertNil(error, "No errors")
//            XCTAssertNotNil(user, "Retrived user")
//            expectations.fulfill()
//        }
//
//        waitForExpectations(timeout: 10) { (error) in
//            if let error = error {
//                XCTFail("\(error)")
//            }
//        }
//    }
    
//    func testWrongCredentials() {
//        let expectations = expectation(description: "Expecting a nil JSON data")
//        interactorUnderTest.login(username: "unknownUser", password: "xxxxx") { (user, error) in
//            XCTAssertNil(user, "No errors")
//            XCTAssertNotNil(error, "Retrived user")
//            expectations.fulfill()
//        }
//
//        waitForExpectations(timeout: 10) { (error) in
//            if let error = error {
//                XCTFail("\(error)")
//            }
//        }
//    }
}
