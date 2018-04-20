//
//  VOYThemesPresenterTests.swift
//  VoyTests
//
//  Created by Dielson Sales on 20/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYThemesPresenterTests: XCTestCase {

    private var mockViewController: VOYMockThemesViewController!
    private var mockDataSource: VOYMockThemesDataSource!
    private var presenterUnderTest: VOYThemesPresenter!

    override func setUp() {
        mockViewController = VOYMockThemesViewController()
        mockDataSource = VOYMockThemesDataSource()
        presenterUnderTest = VOYThemesPresenter(dataSource: mockDataSource, view: mockViewController)
    }

    func testThemesSetup() {
        let expectations = expectation(description: "Set the view model in the viewController")
        presenterUnderTest.onReady()
        DispatchQueue.main.async {
            XCTAssertNotNil(self.mockViewController.viewModel)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
