//
//  VOYReportListRepository.swift
//  Voy
//
//  Created by Rubens Pessoa on 15/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import Foundation

class VOYReportListRepository: VOYReportListDataSource {

    private let networkClient: VOYNetworkClient
    private let reachability: VOYReachability

    init(reachability: VOYReachability = VOYDefaultReachability()) {
        self.reachability = reachability
        self.networkClient = VOYNetworkClient(reachability: reachability)
    }

    func getReportCount(themeId: Int,
                        status: VOYReportStatus,
                        mapper: Int,
                        completion: @escaping (Int?, Error?) -> Void) {
        guard let auth = VOYUser.activeUser()?.authToken else { return }

        let parameters = [ "status": status.rawValue,
                           "mapper": mapper,
                           "page_size": VOYConstant.API.paginationSize,
                           "page": 1,
                           "theme": themeId ]

        let headers = [ "Authorization": "Token \(auth)" ]

        networkClient.requestDictionary(
            urlSuffix: "reports",
            httpMethod: .get,
            parameters: parameters,
            headers: headers,
            completion: { object, error, _ in
                if let count = object?["count"] as? Int {
                    completion(count, nil)
                } else {
                    completion(nil, error)
                }
        })
    }
}
