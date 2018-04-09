//
//  VOYLoginPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 01/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYLoginPresenter {

    weak var view: VOYLoginContract?
    var dataSource: VOYLoginDataSource

    init(dataSource: VOYLoginDataSource, view: VOYLoginContract) {
        self.dataSource = dataSource
        self.view = view
    }

    func login(username: String, password: String) {
        view?.startProgressIndicator()
        dataSource.login(username: username, password: password) { (user, _) in
            self.view?.stopProgressIndicator()
            if user != nil {
                self.view?.redirectController()
            } else {
                // TODO: show show a more specific error
                self.view?.presentErrorAlert()
            }
        }
    }
}
