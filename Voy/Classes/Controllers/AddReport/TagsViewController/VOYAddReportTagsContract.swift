//
//  VOYAddReportTagsContract.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import TagListView

protocol VOYAddReportTagsContract {
    func loadTags()
    func selectTags(tags: [String])
    func navigateToSuccessScreen()
    func showProgress()
    func dismissProgress()
}