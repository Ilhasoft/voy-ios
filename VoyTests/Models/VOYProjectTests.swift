//
//  VOYProject.swift
//  VoyTests
//
//  Created by Dielson Sales on 24/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYProjectTests: XCTestCase {

    var projectUnderTest: VOYProject!

    override func setUp() {
        projectUnderTest = VOYProject()
        projectUnderTest.id = 20
        projectUnderTest.name = "Project Under Test"
    }

    func testActiveProject() {
        VOYProject.setActiveProject(project: projectUnderTest)
        let activeProject: VOYProject! = VOYProject.activeProject()

        XCTAssertEqual(projectUnderTest.id, activeProject.id)
        XCTAssertEqual(projectUnderTest.name, activeProject.name)
    }

    func testMapping() {
        let dictionary: [String: Any] = [
            "id": 20,
            "name": "Project Under Test"
        ]
        let project: VOYProject! = VOYProject(JSON: dictionary)
        XCTAssertEqual(project.id, projectUnderTest.id)
        XCTAssertEqual(project.name, projectUnderTest.name)
    }
}
