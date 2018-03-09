//
//  VOYNotificationPresenter.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYNotificationPresenter {
    var view: VOYNotificationContract!
    var dataSource: VOYNotificationDataSource!
    
    init(dataSource: VOYNotificationDataSource, view: VOYNotificationContract) {
        self.view = view
        self.dataSource = dataSource
    }
    
}
