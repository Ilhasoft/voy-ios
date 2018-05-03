//
//  VOYNotificationRepository.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYNotificationRepository: VOYNotificationDataSource {
    let reachability: VOYReachability
    let networkClient: VOYNetworkClient

    init(reachability: VOYReachability) {
        self.reachability = reachability
        self.networkClient = VOYNetworkClient(reachability: reachability)
    }

    func getNotifications(completion: @escaping ([VOYNotification]?) -> Void) {
        networkClient.requestObjectArray(urlSuffix: "report-notification/",
                                         httpMethod: .get,
                                         headers: networkClient.authorizationHeaders
        ) { (notificationList: [VOYNotification]?, _) in
            guard let notificationList = notificationList else { return }
            completion(notificationList)
        }
    }

    func updateNotification(notification: VOYNotification) {
        guard let auth = VOYUser.activeUser()?.authToken, let notificationId = notification.id else { return }
        let parameters: [String: Any]? = ["read": true]
        networkClient.requestDictionary(urlSuffix: "report-notification/\(notificationId)/",
                                        httpMethod: .put,
                                        parameters: parameters,
                                        headers: networkClient.authorizationHeaders) { (_, _, _)  in }
    }
}
