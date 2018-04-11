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
    var mockedRepository: VOYMockLoginRepository!
    var mockedView: VOYMockLoginViewController!
    var presenterUnderTest: VOYLoginPresenter!
    let validUsername: String = "johnsnow"
    let validPassword: String = "123456"
    let invalidUsername: String = "lannister"
    let invalidPassword: String = "654321"

    override func setUp() {
        super.setUp()
        mockedRepository = VOYMockLoginRepository()
        mockedView = VOYMockLoginViewController()
        presenterUnderTest = VOYLoginPresenter(dataSource: mockedRepository, view: mockedView)
    }

    func testValidLogin() {
        presenterUnderTest.login(username: validUsername, password: validPassword)
        XCTAssertTrue(mockedView.redirectedUser)
        XCTAssertFalse(mockedView.presentedAlert)
    }

    func testInvalidLogin() {
        presenterUnderTest.login(username: invalidUsername, password: invalidPassword)
        XCTAssertFalse(mockedView.redirectedUser)
        XCTAssertTrue(mockedView.presentedAlert)
    }
}
