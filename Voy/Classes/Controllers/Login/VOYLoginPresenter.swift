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
        dataSource.login(username: username, password: password) { (user , error) in
            guard let view = self.view else { return }
            if let _ = error {
                view.redirectController(loginAuth: .error)
            }else if user != nil {
                view.redirectController(loginAuth: .success)
            }else {
                view.redirectController(loginAuth: .error)
            }
        }
    }
}
