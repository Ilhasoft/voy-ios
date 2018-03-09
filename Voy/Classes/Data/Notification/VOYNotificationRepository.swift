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
    
    init(reachability: VOYReachability) {
        self.reachability = reachability
    }
    
    func getNotifications() {
        let request = Alamofire.request(VOYConstant.API.URL + "report-notification", method: .get, parameters: nil, headers: nil)//.request(VOYConstant.API.URL + "report-notification/")
        
        request.responseJSON { (response) in
            print(response.result.value)
            guard let list = response.result.value as? [VOYNotification] else { return }
            print(list)
            print("")
        }
//        request.responseArray { (dataResponse: DataResponse<[VOYNotification]>) in
//            print(dataResponse.result.value)
//            print(dataResponse.result.error)
//            if dataResponse.result.value != nil {
//                let list = dataResponse.result.value
//                print(list)
//            }
//        }
    }
    
    func updateNotification() {
        
    }
}
