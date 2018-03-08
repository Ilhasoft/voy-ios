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
    var dropDownWasSet: Bool
    var startedPresenter: Bool
    var listWasUpdated: Bool
    var cachedList: Bool
    var tableViewWasUpdated: Bool
    var loadedThemesfromProject: Bool    
    var presenter: VOYMockThemeListPresenter!
    
    init() {
        dropDownWasSet = false
        listWasUpdated = false
        tableViewWasUpdated = false
        loadedThemesfromProject = false
        startedPresenter = true
        cachedList = false
        presenter = VOYMockThemeListPresenter(dataSource: VOYMockThemeListRepository(), view: self)
    }
    
    func getProjects() {
        startedPresenter = true
        guard let presenter = presenter else { return }
        presenter.getProjects { (success) in
            if success {
                presenter.cacheData()
                self.cachedList = true
            }
        }
    }
    
    func setupDropDown() {
        dropDownWasSet = true
    }
    
    func projectListWasUpdated() {
        listWasUpdated = true
        setupDropDown()
        guard let project = presenter.projects.first else { return }
        setupTableView(filterThemesByProject: project)
    }
    
    func loadThemesFilteredByProject(project: VOYProject) {
        loadedThemesfromProject = true
    }
    
    func setupTableView(filterThemesByProject project: VOYProject) {
        tableViewWasUpdated = true
        loadThemesFilteredByProject(project: project)
    }
    

}
