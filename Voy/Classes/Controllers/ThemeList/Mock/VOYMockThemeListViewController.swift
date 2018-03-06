//
//  VOYMockThemeListViewController.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYMockThemeListViewController: VOYThemeListContract {
    var dropDownWasSet: Bool = false
    var listWasUpdated: Bool = false
    var tableViewWasUpdated: Bool = false
    var loadedThemesfromProject: Bool = false
    var projects: [VOYProject]! {
        didSet {
            self.projectListWasUpdated()
        }
    }
    
    init() {
        projects = [VOYProject]()
    }
    
    func getProjects() {
        for index in 0 ..< 5 {
            let newProject = VOYProject()
            newProject.name = "New Project"
            newProject.id = index
            self.projects.append(newProject)
        }
    }
    
    func setupDropDown() {
        dropDownWasSet = true
    }
    
    func projectListWasUpdated() {
        listWasUpdated = true
        setupDropDown()
        guard let project = projects.first else { return }
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
