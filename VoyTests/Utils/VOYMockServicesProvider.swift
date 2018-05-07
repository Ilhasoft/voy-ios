//
//  VOYMockServicesProvider.swift
//  VoyTests
//
//  Created by Dielson Sales on 07/05/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYMockServicesProvider {
    static let shared = VOYMockServicesProvider()

    let storageManager: VOYStorageManager = VOYMockStorageManager()
}
