//
//  VOYRemoteRequests.swift
//  Voy
//
//  Created by Dielson Sales on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

func getRequest<T: Mappable>(urlSuffix: String, completion: @escaping (T?, Error?) -> Void) {
    let url = "\(VOYConstant.API.URL)\(urlSuffix)"
    Alamofire.request(url, method: .get)
        .responseArray(completionHandler: { (dataResponse: DataResponse<[T]>) -> Void in
            if let userData = dataResponse.result.value, userData.count > 0 {
                completion(userData.first!, nil)
            } else if let error = dataResponse.result.error {
                completion(nil, error)
            }
        })
}

func postRequest<T>(urlSuffix: String, parameters: [String: Any], completion: @escaping (T?, Error?) -> Void) {
    let url = "\(VOYConstant.API.URL)\(urlSuffix)"
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .responseJSON { (dataResponse: DataResponse<Any>) -> Void in
            if let value = dataResponse.value as? T {
                completion(value, nil)
            } else if let error = dataResponse.result.error {
                completion(nil, error)
            }
    }
}
