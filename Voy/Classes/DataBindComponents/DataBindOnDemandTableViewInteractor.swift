//
//  RestBindProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ISOnDemandTableView
import Alamofire
import ObjectMapper

public class DataBindOnDemandTableViewInteractor: ISOnDemandTableViewInteractor {

    private var endPoint: String!
    private var keyPath: String?
    private var apiURL: String?
    private var params: [String: Any]?
    private var reversedList: Bool!
    private var reachability: VOYReachability
    private let networkClient = VOYNetworkClient(reachability: VOYReachabilityImpl())
    
  init(configuration: DataBindRestConfiguration, params: [String: Any]? = nil, paginationCount: Int, reachability: VOYReachability, reversedList: Bool = false) {
        self.endPoint = configuration.endPoint
        self.keyPath = configuration.keyPath
        self.apiURL = configuration.apiURL
        self.params = params
        self.reachability = reachability
        self.reversedList = reversedList
        super.init(paginationCount: UInt(paginationCount))
    }
    
    override public func fetchObjects(forPage page: UInt,
                                      with handler: (([Any]?, Error?) -> Void)!) {

        var parameters = [String: Any]()
        var headers = [String: String]()

        if !reachability.hasNetwork() {
            headers["Cache-Control"] = "public, only-if-cached, max-stale=86400"
        } else {
            headers["Cache-Control"] = "public, max-age=86400, max-stale=120"
        }

        var url = VOYConstant.API.URL

        if apiURL != nil {
            url = apiURL!
        }

        if let params = self.params {
            parameters = params
        }

        self.currentPage = page == 0 ? 1 : page

        parameters["page_size"] = self.paginationCount
        parameters["page"] = self.currentPage

        networkClient.requestKeyPathDictionary(
            urlSuffix: endPoint,
            httpMethod: .get,
            parameters: parameters,
            headers: headers,
            shouldCacheResponse: true,
            keyPath: keyPath
        ) { objects, error in
            if self.reversedList, let reversedObjects = objects?.reversed() {
                let objects = Array(reversedObjects)
                handler(objects, error)
            } else {
                handler(objects, error)
            }
        }
    }
}
