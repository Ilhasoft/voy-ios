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

    func testGetIdentifier() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"

        let date = dateFormatter.date(from: "23 Apr 2018 18:37:50")!
        let identifier = String.generateIdentifier(from: date)
        XCTAssertEqual(identifier, "2342018183750")
    }

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
