//
//  VOYMockThemeListRepository.swift
//  Voy
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

class VOYMockThemeListRepository: VOYThemeListDataSource {

    var projectList: [VOYProject] = [VOYProject]()
    var userToken: String = "testToken989h9h7h8g8"
    var cachedProjectsCount: Int = 0
    private let reachability: VOYReachability

    init(reachability: VOYReachability) {
        self.reachability = reachability
    }

    func getMyProjects(completion: @escaping ([VOYProject], Error?) -> Void) {
        if reachability.hasNetwork() {
            for i in 0 ..< 5 {
                let project = VOYProject()
                project.id = 98765234 + i
                project.name = "Project Title"
                projectList.append(project)
            }
        }
        completion(projectList, nil)
    }

    func cacheDataFrom(url: String, parameters: inout [String: Any]) {
        if reachability.hasNetwork() {
            cachedProjectsCount += 1
        } else {
            print("Don't have internet connect nor cached data")
        }
    }
    
    func getNotifications(completion: @escaping ([VOYNotification]?) -> Void) {
        implement
    }
}
