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
    private let reportStoreManager = VOYReportStorageManager()

    enum VOYHTTPMethod {
        case get
        case post
        case put
        case delete

        fileprivate func toHttpMethod() -> HTTPMethod {
            switch self {
            case .get:
                return HTTPMethod.get
            case .post:
                return HTTPMethod.post
            case .put:
                return HTTPMethod.put
            case .delete:
                return HTTPMethod.delete
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
                                         completion: @escaping ([T]?, Error?, URLRequest) -> Void) -> URLRequest? {
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
            guard let internalRequest = dataResponse.request else { return }
            if let userData = dataResponse.result.value {
                completion(userData, nil, internalRequest)
            } else if let error = dataResponse.result.error {
                completion(nil, error, internalRequest)
            }
        }
        return request.request
    }

    @discardableResult
    func requestAnyObject(urlSuffix: String,
                          httpMethod: VOYHTTPMethod,
                          parameters: [String: Any]? = nil,
                          headers: [String: String]? = nil,
                          shouldCacheResponse: Bool = false,
                          completion: @escaping (Any?, Error?, URLRequest) -> Void) -> URLRequest? {
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
            guard let internalRequest = dataResponse.request else { return }
            if let value = dataResponse.result.value {
                completion(value, nil, internalRequest)
            } else if let error = dataResponse.result.error {
                completion(nil, error, internalRequest)
            }
        }
        return request.request
    }

    @discardableResult
    func requestDictionary(urlSuffix: String,
                           httpMethod: VOYHTTPMethod,
                           parameters: [String: Any]? = nil,
                           headers: [String: String]? = nil,
                           shouldCacheResponse: Bool = false,
                           useJSONEncoding: Bool = false,
                           completion: @escaping ([String: Any]?, Error?, URLRequest) -> Void) -> URLRequest? {
        let url = createURL(urlSuffix: urlSuffix)
        let request = Alamofire.request(
            url,
            method: httpMethod.toHttpMethod(),
            parameters: parameters,
            encoding: (useJSONEncoding ? JSONEncoding.default : URLEncoding.default),
            headers: headers
        )
        pendingRequests.append(request)
        request.responseJSON { (dataResponse: DataResponse<Any>) in
            self.pendingRequests.removeRequest(request: request)
            guard let internalRequest = dataResponse.request else { return }
            if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
            switch dataResponse.result {
            case .failure(let error):
                completion(nil, error, internalRequest)
            case .success(let value):
                guard let valueDict = value as? [String: Any] else {
                    completion(nil, nil, internalRequest)
                    return
                }
                completion(valueDict, nil, internalRequest)
            }
        }
        return request.request
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
                    let objects = results.map({ return Map(mappingType: .fromJSON, JSON: $0) })
                    completion(objects, nil)
                } else if let results = dataResponse.value as? [[String: Any]] {
                    let objects = results.map({ return Map(mappingType: .fromJSON, JSON: $0) })
                    completion(objects, nil)
                } else if let error = dataResponse.result.error {
                    completion(nil, error)
                }
            }
        } else if let alamofireRequest = request.request,
                  let cachedResponse = URLCache.shared.cachedResponse(for: alamofireRequest) {
            var arrayOfMaps = [[String: Any]]()
            var jsonObject: Any?

            do {
                jsonObject = try JSONSerialization.jsonObject(with: cachedResponse.data, options: [])
            } catch {
                completion([], error)
                return
            }

            if let keyPath = keyPath, let jsonObject = jsonObject as? [String: Any],
                let subobject = jsonObject[keyPath] as? [[String: Any]] {
                arrayOfMaps = subobject
            } else if let jsonObject = jsonObject as? [[String: Any]] {
                arrayOfMaps = jsonObject
            }

            var objects = arrayOfMaps.map({ return Map(mappingType: .fromJSON, JSON: $0) })

            if urlSuffix == "reports" && parameters?["status"] as? Int == 2 {
                for reportJSON in self.reportStoreManager.getPendentReports() {
                    objects.append(Map(mappingType: .fromJSON, JSON: reportJSON))
                }
            }
            completion(objects, nil)
        } else {
            completion([], nil)
        }
    }

    @discardableResult
    func requestObject<T: Mappable>(urlSuffix: String,
                                    httpMethod: VOYHTTPMethod,
                                    parameters: [String: Any]? = nil,
                                    headers: [String: String]? = nil,
                                    shouldCacheResponse: Bool = false,
                                    completion: @escaping (T?, Error?, URLRequest) -> Void) -> URLRequest? {
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
            guard let internalRequest = dataResponse.request else { return }
            self.pendingRequests.removeRequest(request: request)
            if shouldCacheResponse { self.cacheReponse(dataResponse: dataResponse) }
            if let value = dataResponse.value {
                completion(value, nil, internalRequest)
            } else if let error = dataResponse.result.error {
                completion(nil, error, internalRequest)
            }
        }
        return request.request
    }

    // MARK: - Private methods

    private func createURL(urlSuffix: String) -> String {
        return "\(VOYConstant.API.URL)\(urlSuffix)"
    }

    private func cacheReponse<T: Any>(dataResponse: DataResponse<T>) {
        guard let internalRequest = dataResponse.request,
              let internalResponse = dataResponse.response,
              let internalData = dataResponse.data else { return }
        if dataResponse.result.error == nil {
            let cachedURLResponse = CachedURLResponse(
                response: internalResponse,
                data: internalData,
                userInfo: nil,
                storagePolicy: .allowed
            )
            URLCache.shared.storeCachedResponse(cachedURLResponse, for: internalRequest)
        }
    }
}

extension Array where Element: DataRequest {
    /**
     * Removes a request from array by comparing their URLRequest variables (since URLRequest implements Equatable).
     */
    mutating func removeRequest(request: DataRequest) {
        guard let otherRequest = request.request else { return }
        for (index, value) in self.enumerated() {
            if let valueRequest = value.request, valueRequest == otherRequest {
                remove(at: index)
                return
            }
        }
    }
}
