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

    var notifications: [VOYNotification]? {
        didSet {
            self.view.updateTableView()
        }
    }

    init(dataSource: VOYNotificationDataSource, view: VOYNotificationContract) {
        self.view = view
        self.dataSource = dataSource
    }

    func viewDidLoad() {
        dataSource.getNotifications { (notificationList) in
            if let notificationList = notificationList {
                self.notifications = notificationList
            }
        }
    }

    func setupNotificationTitleFor( indexPath: IndexPath) -> String {
        guard let notification = notifications?[indexPath.row] else { return "" }
        if notification.status == 1 {
            return (notification.origin == 1) ?
                localizedString(.reportWasApproved) : localizedString(.commentWasApproved)
        } else {
            return (notification.origin == 1) ?
                localizedString(.reportWasNotApproved) : localizedString(.commentWasNotApproved)
        }
    }

    func userTappedNotificationFrom(index: Int) {
        guard let notification = notifications?[index] else { return }
        dataSource.updateNotification(notification: notification)
        view.userTappedNotification(from: notification.report)
    }
}
