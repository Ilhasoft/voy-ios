//
//  VOYMockThemeListViewController.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
@testable import Voy

class VOYMockThemeListViewController: VOYThemeListContract {
    var listCount: Int = 0

    func updateProjectsList(projects: [VOYProject]) {
        listCount = projects.count
    }
}
