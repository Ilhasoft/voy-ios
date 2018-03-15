//
//  VOYNotificationContract.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYNotificationContract {
    func setupController()
    func updateTableView()
    func fetchNotifications()
    func userTappedNotification(from report: VOYReport)
}