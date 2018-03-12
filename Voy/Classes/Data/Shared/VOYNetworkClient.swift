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
    
    private var pendingRequests: [DataRequest] = []
    private let reachability: VOYReachability

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
    
    init(reachability: VOYReachability) {
        self.reachability = reachability
    }
    
    /**
     * When this object is destroyed, it cancels all of its pending network requests.
     */
    deinit {
        cancelAllRequests()
    }
    
    /**
     * Cancels all pending requests for this wrapper object.
     */
    func cancelAllRequests() {
        for request in pendingRequests {
            request.cancel()
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
        pendingRequests.append(request)
        request.responseArray { (dataResponse: DataResponse<[T]>) in
            self.pendingRequests.removeRequest(request: request)
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
        )
        pendingRequests.append(request)
        request.responseJSON { (dataResponse: DataResponse<Any>) in
            self.pendingRequests.removeRequest(request: request)
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
        pendingRequests.append(request)
        request.responseJSON { (dataResponse: DataResponse<Any>) in
            self.pendingRequests.removeRequest(request: request)
            if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
            if let value = dataResponse.value as? [String: Any] {
                completion(value, nil, dataResponse.request!)
            } else if let error = dataResponse.result.error {
                completion(nil, error, dataResponse.request!)
            }
        }
        return request.request!
    }

    func requestKeyPathDictionary(urlSuffix: String,
                                  httpMethod: VOYHTTPMethod,
                                  parameters: [String: Any]? = nil,
                                  headers: [String: String]? = nil,
                                  shouldCacheResponse: Bool = false,
                                  keyPath: String? = nil,
                                  completion: @escaping ([Any]?, Error?) -> Void) {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            headers: headers
        )
        
        if reachability.hasNetwork() {
            pendingRequests.append(request)
            request.responseJSON { (dataResponse: DataResponse<Any>) in
                self.pendingRequests.removeRequest(request: request)
                if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
                if let keyPath = keyPath,
                    let resultValue = dataResponse.value as? [String: Any],
                    let results = resultValue[keyPath] as? [[String: Any]] {
                    self.prepareForHandleData(results) { objects in
                        completion(objects, nil)
                    }
                } else if let results = dataResponse.value as? [[String: Any]] {
                    self.prepareForHandleData(results) { objects in
                        completion(objects, nil)
                    }
                } else if let error = dataResponse.result.error {
                    completion(nil, error)
                }
            }
        } else if let cachedResponse = URLCache.shared.cachedResponse(for: request.request!) {
            do {
                var objects = [[String: Any]]()
                let jsonObject = try JSONSerialization.jsonObject(with: cachedResponse.data, options: [])
                
                if let keyPath = keyPath,
                    let jsonObject = jsonObject as? [String: Any],
                    let subobject = jsonObject[keyPath] as? [[String: Any]] {
                    objects = subobject
                } else if let jsonObject = jsonObject as? [[String: Any]] {
                    objects = jsonObject
                }
                prepareForHandleData(objects, completion: { (objects) in
                    if urlSuffix == "reports" && parameters?["status"] as? Int == 2 {
                        let pendentReportsJSONList = VOYReportStorageManager.shared.getPendentReports()
                        guard !pendentReportsJSONList.isEmpty else {
                            completion(objects, nil)
                            return
                        }
                        if var objectsAsMap = objects as? [Map] {
                            for reportJSON in pendentReportsJSONList {
                                objectsAsMap.append(Map(mappingType: .fromJSON, JSON: reportJSON))
                            }
                            completion(objectsAsMap, nil)
                        } else {
                            completion(objects, nil)
                        }
                    } else {
                        completion(objects, nil)
                    }
                })
            } catch {
                print(error.localizedDescription)
                completion([], error)
            }
        }
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
        pendingRequests.append(request)
        request.responseObject { (dataResponse: DataResponse<T>) in
            self.pendingRequests.removeRequest(request: request)
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
    
    private func prepareForHandleData(_ arrayDictionary: [[String: Any]], completion: (([Any]) -> Void)!) {
        var objects = [Map]()
        
        for result in arrayDictionary {
            let object = Map(mappingType: .fromJSON, JSON: result)
            objects.append(object)
        }
        completion(objects)
    }
}

extension Array where Element: DataRequest {
    /**
     * Removes a request from array by comparing their URLRequest variables (since URLRequest implements Equatable).
     */
    mutating func removeRequest(request: DataRequest) {
        for (index, value) in self.enumerated() where value.request! == request.request! {
            remove(at: index)
            return
        }
    }
}
