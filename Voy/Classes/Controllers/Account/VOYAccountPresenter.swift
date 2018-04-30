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

    func onScreenLoaded() {
        guard let user = VOYUser.activeUser() else { return }
        view?.setupLoading(showLoading: true)
        dataSource.downloadAvatarImage(avatarURL: user.avatar) { (image: UIImage?) in
            self.view?.setupLoading(showLoading: false)
            var fullName: String = user.username
            if let firstName = user.first_name, let lastName = user.last_name {
                fullName = "\(firstName) \(lastName)"
            }
            let viewModel = VOYAccountViewModel(fullName: fullName, email: user.email, avatarImage: image)
            self.view?.update(with: viewModel)
        }
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
