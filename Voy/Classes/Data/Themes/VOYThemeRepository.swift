//
//  VOYThemeRepository.swift
//  Voy
//
//  Created by Dielson Sales on 18/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYThemeRepository: VOYThemesDataSource {

    private let reachability: VOYReachability
    private let storageManager: VOYStorageManager
    private let networkClient: VOYNetworkClient

    init(reachability: VOYReachability = VOYDefaultReachability(),
         storageManager: VOYStorageManager = VOYDefaultStorageManager()) {
        self.reachability = reachability
        self.storageManager = storageManager
        self.networkClient = VOYNetworkClient(reachability: reachability, storageManager: storageManager)
    }

    func getProjects(forUser user: VOYUser, completion: @escaping ([VOYProject]) -> Void) {
        if reachability.hasNetwork() {
            guard let authToken = user.authToken else {
                completion([])
                return
            }
            networkClient.requestObjectArray(
                urlSuffix: "projects/",
                httpMethod: .get,
                headers: ["Authorization": "Token \(authToken)"]
            ) { (projects: [VOYProject]?, _) in
                if let projects = projects {
                    self.storageManager.setProjects(projects)
                    completion(projects)
                } else {
                    completion([])
                }
            }
        } else {
            completion(storageManager.getProjects())
        }
    }

    func getThemes(forProject project: VOYProject, user: VOYUser, completion: @escaping ([VOYTheme]) -> Void) {
        if reachability.hasNetwork() {
            guard let projectId = project.id, let userId = user.id else {
                completion([])
                return
            }
            networkClient.requestObjectArray(
                urlSuffix: "themes/?project=\(projectId)&user=\(userId)",
                httpMethod: .get
            ) { (themes: [VOYTheme]?, _) in
                if let themes = themes {
                    self.storageManager.setThemes(forProject: project, themes)
                    completion(themes)
                } else {
                    completion([])
                }
            }
        } else {
            completion(storageManager.getThemes(forProject: project))
        }
    }

    func getNotifications(withUser user: VOYUser, completion: @escaping ([VOYNotification]) -> Void) {
        guard let auth = user.authToken else {
            completion([])
            return
        }
        networkClient.requestObjectArray(urlSuffix: "report-notification/",
                                         httpMethod: VOYNetworkClient.VOYHTTPMethod.get,
                                         headers: ["Authorization": "Token \(auth)"]
        ) { (notificationsList: [VOYNotification]?, _) in
            if let notificationsList = notificationsList {
                completion(notificationsList)
            } else {
                completion([])
            }
        }
    }
}
