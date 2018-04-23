//
//  VOYThemesViewModel.swift
//  Voy
//
//  Created by Dielson Sales on 19/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

struct VOYThemesViewModel {
    let themes: [VOYProject: [VOYTheme]]
    let selectedProject: VOYProject?

    func themesForSelectedProject() -> [VOYTheme] {
        if let selectedProject = self.selectedProject, let themes = themes[selectedProject] {
            return themes
        }
        return []
    }
}
