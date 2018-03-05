//
//  VOYMockThemeListRepository.swift
//  Voy
//
//  Created by Pericles Jr on 05/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYMockThemeListRepository: VOYThemeListDataSource {
    
    var projectList: [VOYProject] = [VOYProject]()
    var userToken: String = "testToken989h9h7h8g8"
    var hasNetWork: Bool = true
    
    func getMyProjects(completion: @escaping ([VOYProject], Error?) -> Void) {
        for i in 0 ..< 5 {
            let project = VOYProject()
            project.id = 98765234 + i
            project.name = "Project Title"
            projectList.append(project)
        }
        if hasNetWork {
            completion(projectList, nil)
        } else {
            completion(projectList, nil)
        }
    }
    
    func cacheDataFrom(url: String, parameters: inout [String : Any]) {
        if hasNetWork {
            for project in projectList {
                if project.id != nil {
                    print("Project stored")
                }
            }
        } else {
            print("Don't have internet connect nor cached data")
        }
    }
    
    
}
