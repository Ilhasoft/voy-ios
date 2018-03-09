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

class VOYNetworkClient {

    enum VOYHTTPMethod {
        case get
        case post
        case put

        fileprivate func toHttpMethod() -> HTTPMethod {
            switch self {
            case .get:
                return HTTPMethod.get
            case .post:
                return HTTPMethod.post
            case .put:
                return HTTPMethod.put
            }
        }
    }

    func requestArray<T: Mappable>(urlSuffix: String,
                                   httpMethod: VOYHTTPMethod,
                                   parameters: [String: Any]? = nil,
                                   headers: [String: String]? = nil,
                                   completion: @escaping ([T]?, Error?) -> Void) {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        request.responseArray { (dataResponse: DataResponse<[T]>) in
            if let userData = dataResponse.result.value {
                completion(userData, nil)
            } else if let error = dataResponse.result.error {
                completion(nil, error)
            }
        }
    }

    func requestDictionary(urlSuffix: String,
                           httpMethod: VOYHTTPMethod,
                           parameters: [String: Any]? = nil,
                           headers: [String: String]? = nil,
                           completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        request.responseJSON { (dataResponse: DataResponse<Any>) in
            if let value = dataResponse.value as? [String: Any] {
                completion(value, nil)
            } else if let error = dataResponse.result.error {
                completion(nil, error)
            }
        }
    }

    func requestObject<T: Mappable>(urlSuffix: String,
                                    httpMethod: VOYHTTPMethod,
                                    parameters: [String: Any]? = nil,
                                    headers: [String: String]? = nil,
                                    completion: @escaping (T?, Error?) -> Void) {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        request.responseObject { (dataResponse: DataResponse<T>) in
            if let value = dataResponse.value {
                completion(value, nil)
            } else if let error = dataResponse.result.error {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func createURL(urlSuffix: String) -> String {
        return "\(VOYConstant.API.URL)\(urlSuffix)"
    }
}
