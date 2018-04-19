//
//  VOYThemesPresenter.swift
//  Voy
//
//  Created by Dielson Sales on 17/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYThemesPresenter {
    private let dataSource: VOYThemesDataSource

    private var projects: [VOYProject: [VOYTheme]?] = [:]
    private var retrievedThemesCount = 0
    weak var view: VOYThemesContract?

    init(dataSource: VOYThemesDataSource = VOYThemeRepository(), view: VOYThemesContract) {
        self.dataSource = dataSource
        self.view = view
    }

    func onReady() {
        view?.showProgress()
        guard let activeUser = assertExists(optionalVar: VOYUser.activeUser()) else { return }
        dataSource.getProjects(forUser: activeUser) { projects in
            for project in projects {
                self.projects[project] = []
                self.dataSource.getThemes(forProject: project) { themes in
                    DispatchQueue.main.async {
                        self.projects[project] = themes
                        self.retrievedThemesCount += 1
                        if self.retrievedThemesCount == self.projects.count {
                            self.view?.dismissProgress()
                        }
                    }
                }
            }
        }
    }
}
