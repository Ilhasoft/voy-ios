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

    private var projects: [VOYProject] = []
    private var themes: [VOYTheme] = []
    weak var view: VOYThemesContract?

    init(dataSource: VOYThemesDataSource = VOYThemeRepository(), view: VOYThemesContract) {
        self.dataSource = dataSource
        self.view = view
    }

    func onReady() {
        view?.showProgress()
        dataSource.getProjects { [weak self] projects in
            self?.projects = projects
            self?.dataSource.getThemes { themes in
                self?.themes = themes
                self?.view?.dismissProgress()
            }
        }
    }
}
