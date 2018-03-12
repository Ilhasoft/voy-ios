//
//  VOYThemeListPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYThemeListPresenter {
    weak var view: VOYThemeListContract?
    var dataSource: VOYThemeListDataSource
    
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
    
    func getNotifications() {
        dataSource.getNotifications { (notifications) in
//            if let notifications != nil {
//                VOYThemeListViewController.badgeView.isHidden
//            }
        }
    }
    
    func getProjects(completion:@escaping(Bool) -> Void) {
        dataSource.getMyProjects { (projects, _) in
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
            var params = ["project": project.id as Any, "user": VOYUser.activeUser()!.id]
            dataSource.cacheDataFrom(url: VOYConstant.API.URL + "themes", parameters: &params)
        }
    }
}
