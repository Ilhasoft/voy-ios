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
    let networkClient = VOYNetworkClient()
    
    init(reachability: VOYReachability) {
        self.reachability = reachability
    }
    
    func getNotifications(completion: @escaping ([VOYNotification]?) -> Void) {
        guard let auth = VOYUser.activeUser()?.authToken else { return }
        
//        networkClient.requestArray(urlSuffix: "report-notification",
//                                   httpMethod: VOYNetworkClient.VOYHTTPMethod.get,
//                                   headers: ["Authorization": "Token \(auth)"]) { (notificationList: [VOYNotification]?, error) in
//            guard let notificationList = notificationList else { return }
//            completion(notificationList)
//        }
        
        let request = Alamofire.request(
            VOYConstant.API.URL + "report-notification/",
            method: .get,
            headers: ["Authorization": "Token \(auth)"]
        )
        request.responseArray { (dataResponse: DataResponse<[VOYNotification]>) in
            guard let notificationList = dataResponse.result.value else { return }
            completion(notificationList)
        }
    }
    
    func updateNotification() {
        
    }
}
