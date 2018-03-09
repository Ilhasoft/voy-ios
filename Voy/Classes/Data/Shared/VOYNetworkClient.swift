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

    @discardableResult
    func requestObjectArray<T: Mappable>(urlSuffix: String,
                                   httpMethod: VOYHTTPMethod,
                                   parameters: [String: Any]? = nil,
                                   headers: [String: String]? = nil,
                                   shouldCacheResponse: Bool = false,
                                   completion: @escaping ([T]?, Error?, URLRequest) -> Void) -> URLRequest {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        request.responseArray { (dataResponse: DataResponse<[T]>) in
            if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
            if let userData = dataResponse.result.value {
                completion(userData, nil, dataResponse.request!)
            } else if let error = dataResponse.result.error {
                completion(nil, error, dataResponse.request!)
            }
        }
        return request.request!
    }
    
    @discardableResult
    func requestAnyObject(urlSuffix: String,
                          httpMethod: VOYHTTPMethod,
                          parameters: [String: Any]? = nil,
                          headers: [String: String]? = nil,
                          shouldCacheResponse: Bool = false,
                          completion: @escaping (Any?, Error?, URLRequest) -> Void) -> URLRequest {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON { (dataResponse: DataResponse<Any>) in
            if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
            if let value = dataResponse.result.value {
                completion(value, nil, dataResponse.request!)
            } else if let error = dataResponse.result.error {
                completion(nil, error, dataResponse.request!)
            }
        }
        return request.request!
    }

    @discardableResult
    func requestDictionary(urlSuffix: String,
                           httpMethod: VOYHTTPMethod,
                           parameters: [String: Any]? = nil,
                           headers: [String: String]? = nil,
                           shouldCacheResponse: Bool = false,
                           completion: @escaping ([String: Any]?, Error?, URLRequest) -> Void) -> URLRequest {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        request.responseJSON { (dataResponse: DataResponse<Any>) in
            if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
            if let value = dataResponse.value as? [String: Any] {
                completion(value, nil, dataResponse.request!)
            } else if let error = dataResponse.result.error {
                completion(nil, error, dataResponse.request!)
            }
        }
        return request.request!
    }

    @discardableResult
    func requestObject<T: Mappable>(urlSuffix: String,
                                    httpMethod: VOYHTTPMethod,
                                    parameters: [String: Any]? = nil,
                                    headers: [String: String]? = nil,
                                    shouldCacheResponse: Bool = false,
                                    completion: @escaping (T?, Error?, URLRequest) -> Void) -> URLRequest {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        request.responseObject { (dataResponse: DataResponse<T>) in
            if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
            if let value = dataResponse.value {
                completion(value, nil, dataResponse.request!)
            } else if let error = dataResponse.result.error {
                completion(nil, error, dataResponse.request!)
            }
        }
        return request.request!
    }
    
    // MARK: - Private methods
    
    private func createURL(urlSuffix: String) -> String {
        return "\(VOYConstant.API.URL)\(urlSuffix)"
    }
    
    private func cacheReponse<T: Any>(dataResponse: DataResponse<T>) {
        if dataResponse.result.error == nil {
            let cachedURLResponse = CachedURLResponse(
                response: dataResponse.response!,
                data: dataResponse.data!,
                userInfo: nil,
                storagePolicy: .allowed
            )
            URLCache.shared.storeCachedResponse(cachedURLResponse, for: dataResponse.request!)
        }
    }
}
