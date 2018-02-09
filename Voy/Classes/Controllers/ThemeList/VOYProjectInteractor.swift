//
//  VOYReportInteractor.swift
//  Voy
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class VOYProjectInteractor: NSObject {

    static func getMyProjects(completion:@escaping(_ projects:[VOYProject], _ error: Error?) -> Void) {
        Alamofire.request(VOYConstant.API.URL + "projects", method: .get, parameters: ["auth_token":VOYUser.activeUser()!.authToken]).responseArray { (dataResponse:DataResponse<[VOYProject]>) in
            if let projects = dataResponse.result.value {
                completion(projects, nil)
            }else if let error = dataResponse.result.error {
                completion([], error)
            }
        }
    }
    
}
