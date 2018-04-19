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

    func getProjects(completion: @escaping ([VOYProject]) -> Void) {
        if reachability.hasNetwork() {
            networkClient.requestObjectArray(urlSuffix: "projects/", httpMethod: .get) { (projects: [VOYProject]?, error, request) in
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

    func getThemes(completion: @escaping ([VOYTheme]) -> Void) {
        if reachability.hasNetwork() {
            networkClient.requestObjectArray(urlSuffix: "themes/", httpMethod: .get) { (themes: [VOYTheme]?, error, request) in
                if let themes = themes {
                    self.storageManager.setThemes(themes)
                    completion(themes)
                } else {
                    completion([])
                }
            }
        } else {
            completion(storageManager.getThemes())
        }
    }
}
