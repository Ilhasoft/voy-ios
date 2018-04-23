//
//  VOYMockThemesDataSource.swift
//  VoyTests
//
//  Created by Dielson Sales on 20/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYMockThemesDataSource: VOYThemesDataSource {

    var projects: [VOYProject] = []
    var themes: [VOYTheme] = []
    var notifications: [VOYNotification] = []

    init() {
        let theme1 = VOYTheme()
        theme1.id = 466
        theme1.name = "Theme1"
        theme1.description = "Theme created for a test"
        theme1.tags = ["tag1", "tag2"]
        theme1.color = "62ae7e"

        let theme2 = VOYTheme()
        theme2.id = 467
        theme2.name = "Theme2"
        theme2.description = "Another description"
        theme2.tags = ["tag3", "tag4"]
        theme2.color = "d6bd7d"

        themes = [theme1, theme2]

        let project1 = VOYProject()
        project1.id = 1
        project1.name = "Project 1"

        let project2 = VOYProject()
        project2.id = 2
        project2.name = "Project 2"

        projects = [project1, project2]
    }

    func getProjects(forUser user: VOYUser, completion: @escaping ([VOYProject]) -> Void) {
        completion(projects)
    }

    func getThemes(forProject project: VOYProject, user: VOYUser, completion: @escaping ([VOYTheme]) -> Void) {
        completion(themes)
    }

    func getNotifications(withUser user: VOYUser, completion: @escaping ([VOYNotification]) -> Void) {
        let report = VOYReport()
        report.id = 89
        let notification = VOYNotification(body: "Your report needs improvement", report: report)
        completion(notifications)
    }
}
