//
//  VOYThemeListRepository.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class VOYThemeListRepository: VOYThemeListDataSource {
    
    let reachability: VOYReachability
    let networkClient: VOYNetworkClient

    init(reachability: VOYReachability) {
        self.reachability = reachability
        networkClient = VOYNetworkClient(reachability: self.reachability)
    }
    
    func getNotifications(completion: @escaping ([VOYNotification]?) -> Void) {
        guard let auth = VOYUser.activeUser()?.authToken else { return }
        networkClient.requestObjectArray(urlSuffix: "report-notification/",
                                   httpMethod: VOYNetworkClient.VOYHTTPMethod.get,
                                   headers: ["Authorization": "Token \(auth)"]
        ) { (notificationList: [VOYNotification]?, _, _) in
                                    guard let notificationList = notificationList else { return }
                                    completion(notificationList)
        }
    }
    
    func cacheDataFrom(url: String, parameters: inout [String: Any], headers: inout [String: String]) {
        if reachability.hasNetwork() {
            var headers = [String: String]()
            headers["Cache-Control"] = "public, max-age=86400, max-stale=120"
            parameters["page"] = 1
            parameters["page_size"] = VOYConstant.API.paginationSize
            Alamofire.request(url, method: .get, parameters: parameters, headers: headers)
                .responseJSON { (dataResponse: DataResponse<Any>) in
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
        } else {
            print("User haven't internet connection and don't have cached data")
        }
    }
    
    func getMyProjects(completion: @escaping(_ projects: [VOYProject], _ error: Error?) -> Void) {
        
        guard let activeUser = VOYUser.activeUser(), let authToken = activeUser.authToken else {
            return
        }
        
        var headers = [String: String]()
        if !reachability.hasNetwork() {
            headers["Cache-Control"] = "public, only-if-cached, max-stale=86400"
        } else {
            headers["Cache-Control"] = "public, max-age=86400, max-stale=120"
        }
        headers[VOYConstant.API.authHeader] = "Token \(authToken)"

        let request = Alamofire.request(VOYConstant.API.URL + "projects/", headers: headers)

        var cachedResponse: CachedURLResponse?
        if let alamofireRequest = request.request {
            cachedResponse = URLCache.shared.cachedResponse(for: alamofireRequest)
        }

        if reachability.hasNetwork() {

            request.responseArray { (dataResponse: DataResponse<[VOYProject]>) in
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
                if let projects = dataResponse.result.value {
                    completion(projects, nil)
                } else if let error = dataResponse.result.error {
                    completion([], error)
                }
            }
        } else if let cachedResponse = cachedResponse {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: cachedResponse.data, options: [])
                if let arrayDictionary = jsonObject as? [[String: Any]] {
                    var projects = [VOYProject]()
                    for dictionary in arrayDictionary {
                        if let project = VOYProject(JSON: dictionary) {
                            projects.append(project)
                        }
                    }
                    completion(projects, nil)
                }
            } catch {
                print(error.localizedDescription)
                completion([], error)
            }
        }
    }
}
