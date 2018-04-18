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

    func getThemes(completion: ([VOYTheme]) -> Void) {
        if reachability.hasNetwork() {
            // TODO: request remotely
        } else {
            storageManager.getThemes(completion: completion)
        }
    }
}
