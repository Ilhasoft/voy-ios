//
//  VOYCommentTests.swift
//  VoyTests
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYCommentTests: XCTestCase {
    var repositoryUnderTest: VOYMockCommentRepository!
    
    override func setUp() {
        super.setUp()
        repositoryUnderTest = VOYMockCommentRepository()
    }
    
    override func tearDown() {
        repositoryUnderTest = nil
        super.tearDown()
    }
    
    // MARK: - Data test
    func testSaveComment() {
        let newComment = VOYComment(text: "JustASimpleComment", reportID: 0998080)
        let expectations = expectation(description: "Should get no errors")
        repositoryUnderTest.save(comment: newComment) { (error) in
            XCTAssertNil(error)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
