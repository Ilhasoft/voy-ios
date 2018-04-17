//
//  String.swift
//  VoyTests
//
//  Created by Dielson Sales on 17/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class StringTests: XCTestCase {

    func testValidURLs() {
        XCTAssertFalse("ytc".isValidURL)
        XCTAssertFalse("".isValidURL)
        XCTAssertTrue("google.com".isValidURL)
        XCTAssertTrue("http://google.com".isValidURL)
        XCTAssertTrue("https://google.com".isValidURL)
        XCTAssertTrue("https://www.google.com".isValidURL)
        XCTAssertFalse("https://www@google.com".isValidURL)
    }
}
