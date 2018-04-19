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

    init(reachability: VOYReachability = VOYDefaultReachability(),
         storageManager: VOYStorageManager = VOYDefaultStorageManager()) {
        self.reachability = reachability
        self.storageManager = storageManager
    }

    func getProjects(completion: ([VOYProject]) -> Void) {
        if reachability.hasNetwork() {
            // TODO: request remotely
            //storageManager.setProjects([])
        } else {
            completion(storageManager.getProjects())
        }
    }

    func getThemes(completion: ([VOYTheme]) -> Void) {
        if reachability.hasNetwork() {
            // TODO: request remotely
            //storageManager.setThemes([])
        } else {
            completion(storageManager.getThemes())
        }
    }
}
