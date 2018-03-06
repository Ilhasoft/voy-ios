//
//  VOYMockThemeListPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYMockThemeListPresenter: NSObject {
    weak var view: VOYThemeListContract?
    var dataSource: VOYThemeListDataSource
    let userID: Int = 00000000000
    
    var projects = [VOYProject]() {
        didSet {
            guard let view = self.view else { return }
            view.projectListWasUpdated()
        }
    }
    
    init(dataSource: VOYThemeListDataSource, view: VOYThemeListContract) {
        self.dataSource = dataSource
        self.view = view
    }
    
    func getProjects(completion:@escaping(Bool) -> Void) {
        dataSource.getMyProjects { (projects, error) in
            if projects.count > 0 {
                self.projects = projects
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func cacheData() {
        for project in projects {
            var params = ["project":project.id as Any, "user":userID]
            dataSource.cacheDataFrom(url: VOYConstant.API.URL + "themes", parameters: &params)
        }
    }
}
