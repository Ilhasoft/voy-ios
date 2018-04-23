//
//  VOYThemeTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 23/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYThemeTests: XCTestCase {

    var themeUnderTest: VOYTheme!

    override func setUp() {
        themeUnderTest = VOYTheme()
        themeUnderTest.id = 10
        themeUnderTest.name = "Theme2"
        themeUnderTest.description = "Another description"
        themeUnderTest.tags = ["tag3", "tag4"]
        themeUnderTest.color = "d6bd7d"
    }

    func testSetThemeAsDefault() {
        VOYTheme.setActiveTheme(theme: themeUnderTest)

        let activeTheme = VOYTheme.activeTheme()!
        XCTAssertEqual(activeTheme.id, themeUnderTest.id)
        XCTAssertEqual(activeTheme.name, themeUnderTest.name)
        XCTAssertEqual(activeTheme.description, themeUnderTest.description)
        XCTAssertEqual(activeTheme.tags, themeUnderTest.tags)
        XCTAssertEqual(activeTheme.color, themeUnderTest.color)
    }


}
