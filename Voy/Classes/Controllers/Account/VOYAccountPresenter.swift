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
    
    init(dataSource: VOYAccountDataSource, view: VOYAccountContract) {
        self.dataSource = dataSource
        self.view = view
    }
    
    func updateUser(avatar: Int?, password: String?, completion: @escaping(Error?) -> Void) {
        self.dataSource.updateUser(avatar: avatar, password: password) { (error) in
            completion(error)
        }
    }
}
