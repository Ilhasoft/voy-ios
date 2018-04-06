//
//  VOYAccountPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYAccountPresenter {

    weak var view: VOYAccountContract?
    var dataSource: VOYAccountDataSource
    let storageManager: VOYStorageManager

    init(dataSource: VOYAccountDataSource,
         view: VOYAccountContract,
         storageManager: VOYStorageManager = VOYDefaultStorageManager()) {
        self.dataSource = dataSource
        self.view = view
        self.storageManager = storageManager
    }

    func updateUser(avatar: Int?, password: String?) {
        if avatar != nil || password != nil {
            view?.setupLoading(showLoading: true)
            self.dataSource.updateUser(avatar: avatar, password: password) { _ in
                self.view?.setupLoading(showLoading: false)
            }
        }
    }

    func logoutUser() {
        VOYUser.deactiveUser()
        let navigationController = UINavigationController(rootViewController: VOYLoginViewController())
        UIViewController.switchRootViewController(navigationController, animated: true, completion: {
            self.clearAllCachedData()
        })
    }

    func clearAllCachedData() {
        storageManager.clearAllOfflineData()
        URLCache.shared.removeAllCachedResponses()
    }
}
