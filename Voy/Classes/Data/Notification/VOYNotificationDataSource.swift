//
//  VOYNotificationDataSource.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYNotificationDataSource {
    func getNotifications(completion: @escaping ([VOYNotification]?) -> Void)
    func updateNotification(notification: VOYNotification)
}
