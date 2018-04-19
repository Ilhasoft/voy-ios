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

    private var themes: [VOYProject: [VOYTheme]] = [:]
    private var selectedProject: VOYProject?
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
            if let firstProject = projects.first { self.selectedProject = firstProject }
            for project in projects {
                self.themes[project] = []
                self.dataSource.getThemes(forProject: project) { themes in
                    DispatchQueue.main.async {
                        self.themes[project] = themes
                        self.retrievedThemesCount += 1
                        if self.retrievedThemesCount == self.themes.count {
                            let viewModel = VOYThemesViewModel(
                                themes: self.themes,
                                selectedProject: self.selectedProject
                            )
                            self.view?.dismissProgress()
                            self.view?.update(with: viewModel)
                        }
                    }
                }
            }
        }
    }
}
