//
//  VOYThemeListContract.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYThemeListContract: class {
    func getProjects()
    func setupDropDown()
    func projectListWasUpdated()
    func loadThemesFilteredByProject(project: VOYProject)
    func setupTableView(filterThemesByProject project: VOYProject)
}
