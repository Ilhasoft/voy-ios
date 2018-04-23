//
//  OptionalTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 23/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class OptionalTests: XCTestCase {

    var stringUnderTest: String?

    func testIsEmptyOrNil() {
        stringUnderTest = nil
        XCTAssertTrue(isEmptyOrNil(string: stringUnderTest))

        stringUnderTest = ""
        XCTAssertTrue(isEmptyOrNil(string: stringUnderTest))

        stringUnderTest = "Not empty"
        XCTAssertFalse(isEmptyOrNil(string: stringUnderTest))
    }

}
