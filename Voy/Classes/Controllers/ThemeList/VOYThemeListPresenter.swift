//
//  VOYThemeListPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYThemeListPresenter {
    private weak var view: VOYThemeListContract?
    private var dataSource: VOYThemeListDataSource
    private var userJustLogged: Bool
    var projects = [VOYProject]()

    init(view: VOYThemeListContract, dataSource: VOYThemeListDataSource, userJustLogged: Bool) {
        self.dataSource = dataSource
        self.view = view
        self.userJustLogged = userJustLogged
    }

    func onViewDidLoad() {
        getProjects()
    }

    func updateNotifications() {
        dataSource.getNotifications { (notifications) in
            if notifications != nil, let notificationListUpdated = notifications {
                if notificationListUpdated.count > 0 {
                    VOYThemeListViewController.badgeView.isHidden = false
                }
            }
        }
    }
    
    // MARK: - Private methods

    private func getProjects() {
        dataSource.getMyProjects { (projects, _) in
            if projects.count > 0 {
                self.projects = projects
                if self.userJustLogged {
                    self.cacheData()
                    self.userJustLogged = false
                }
                self.view?.updateProjectsList(projects: projects)
            }
        }
    }

    private func cacheData() {
        for project in projects {
            var params = ["project": project.id as Any, "user": VOYUser.activeUser()!.id]
            dataSource.cacheDataFrom(url: VOYConstant.API.URL + "themes", parameters: &params)
        }
    }
}
