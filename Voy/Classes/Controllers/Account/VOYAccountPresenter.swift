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
         storageManager: VOYStorageManager) {
        self.dataSource = dataSource
        self.view = view
        self.storageManager = storageManager
    }

    func onScreenLoaded() {
        guard let user = VOYUser.activeUser() else { return }
        view?.showProgress()
        dataSource.downloadAvatarImage(avatarURL: user.avatar) { (image: UIImage?) in
            self.view?.hideProgress()
            var fullName: String = user.username
            if let firstName = user.first_name, let lastName = user.last_name {
                fullName = "\(firstName) \(lastName)"
            }
            let viewModel = VOYAccountViewModel(fullName: fullName, email: user.email, avatarImage: image)
            self.view?.update(with: viewModel)
        }
    }

    func onLogoutAction() {
        let isThereOfflineData = !storageManager.getPendingCameraData().isEmpty
            || !storageManager.getPendingReports().isEmpty

        let logoutMessage = isThereOfflineData ? localizedString(.areYouSurePending) : localizedString(.areYouSureEmpty)
        view?.showLogoutConfirmation(message: logoutMessage)
    }

    func updateUser(avatar: Int?, password: String?) {
        if avatar != nil || password != nil {
            view?.showProgress()
            self.dataSource.updateUser(avatar: avatar, password: password) { _ in
                self.view?.hideProgress()
            }
        }
    }

    func logoutUser() {
        VOYUser.deactiveUser()
        clearAllCachedData()
        view?.navigateToLoginScreen()
    }

    func clearAllCachedData() {
        storageManager.clearAllOfflineData()
        URLCache.shared.removeAllCachedResponses()
    }
}
