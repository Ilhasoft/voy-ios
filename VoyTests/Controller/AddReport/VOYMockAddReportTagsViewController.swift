//
//  VOYMockAddReportTagsViewController.swift
//  Voy
//
//  Created by Pericles Jr on 07/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import TagListView
import XCTest
@testable import Voy

class VOYMockAddReportTagsViewController: VOYAddReportTagsContract {
    var stopedAnimation: Bool = false
    var startedAnimation: Bool = false
    var showedSuccess: Bool = false
    var userTappedSave: Bool = false
    var loadedTags: Bool = false
    var updatedSelectedTags: Bool = false
    
    var presenter: VOYAddReportTagsPresenter?

    init() {
        loadTags()
        selectTags()
    }
    
    func loadTags() {
        loadedTags = true
    }
    
    func selectTags() {
        updatedSelectedTags = true
    }
    
    func addTag(tagView: TagView, title: String) {
        
    }
    
    func save() {
        guard let presenter = self.presenter else { return }
        userTappedSave = true
        let newReport = VOYReport()
        newReport.id = 234567
        newReport.name = "New Report"
        presenter.saveReport(report: newReport)
    }
    
    func navigateToSuccessScreen() {
        showedSuccess = true
    }
    
    func stopLoadingAnimation() {
        stopedAnimation = true
    }
    
    func startLoadingAnimation() {
        startedAnimation = true
    }
}
