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
import AlamofireObjectMapper
import AlamofireImage

class VOYNetworkClient {

    private var pendingRequests: [DataRequest] = []
    private let reachability: VOYReachability
    private let storageManager: VOYStorageManager

    var authorizationHeaders: [String: String] {
        var headers: [String: String] = [:]
        if let authToken = VOYUser.activeUser()?.authToken {
            headers[VOYConstant.API.authHeader] = "Token \(authToken)"
        }
        return headers
    }

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

    init(reachability: VOYReachability,
         storageManager: VOYStorageManager = VOYDefaultStorageManager()) {
        self.reachability = reachability
        self.storageManager = storageManager
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

    func requestObjectArray<T: Mappable>(urlSuffix: String,
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
        pendingRequests.append(request)
        request.responseArray { (dataResponse: DataResponse<[T]>) in
            self.pendingRequests.removeRequest(request: request)
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
                           useJSONEncoding: Bool = false,
                           completion: @escaping ([String: Any]?, Error?, URLRequest) -> Void) {
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
            var arrayOfDictionaries = [[String: Any]]()
            var jsonObject: Any?

            do {
                jsonObject = try JSONSerialization.jsonObject(with: cachedResponse.data, options: [])
            } catch {
                completion([], error)
                return
            }

            if let keyPath = keyPath, let jsonObject = jsonObject as? [String: Any],
                let subobject = jsonObject[keyPath] as? [[String: Any]] {
                arrayOfDictionaries = subobject
            } else if let jsonObject = jsonObject as? [[String: Any]] {
                arrayOfDictionaries = jsonObject
            }

            if urlSuffix == "reports" && parameters?["status"] as? Int == 2 {
                for offlineReport in self.storageManager.getPendingReports() {
                    for (index, dictionary) in arrayOfDictionaries.enumerated() {
                        if let dictionaryId = dictionary["id"] as? Int,
                            let localReportId = offlineReport["id"] as? Int,
                            dictionaryId == localReportId {
                            arrayOfDictionaries.remove(at: index)
                            break
                        }
                    }
                    arrayOfDictionaries.append(offlineReport)
                }
            }
            let objects = arrayOfDictionaries.map({ return Map(mappingType: .fromJSON, JSON: $0) })
            completion(objects, nil)
        } else {
            var objects: [Map] = []
            if urlSuffix == "reports" && parameters?["status"] as? Int == 2 {
                for reportJSON in self.storageManager.getPendingReports() {
                    objects.append(Map(mappingType: .fromJSON, JSON: reportJSON))
                }
            }
            completion(objects, nil)
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
        pendingRequests.append(request)
        request.responseObject { (dataResponse: DataResponse<T>) in
            self.pendingRequests.removeRequest(request: request)
            if let value = dataResponse.value {
                completion(value, nil)
            } else if let error = dataResponse.result.error {
                completion(nil, error)
            }
        }
    }

    func requestImage(url: String, completion: @escaping (UIImage?, Error?) -> Void) {
        Alamofire.request(url).responseImage { responseImage in
            if let error = responseImage.error {
                completion(nil, error)
            } else if let image = responseImage.value {
                completion(image, nil)
            } else {
                completion(nil, nil)
            }
        }
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
