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
    
    init(reachability: VOYReachability = VOYReachabilityImpl()) {
        self.reachability = reachability
        self.networkClient = VOYNetworkClient(reachability: reachability)
    }
    
    func getReportCount(themeId: Int,
                        status: VOYReportStatus,
                        mapper: Int,
                        completion: @escaping (Int?, Error?) -> Void) {
        switch status {
        case .approved:
//                    networkClient.requestObject(urlSuffix: <#T##String#>, httpMethod: <#T##VOYNetworkClient.VOYHTTPMethod#>, completion: <#T##(Mappable?, Error?, URLRequest) -> Void#>)
        case .pendent:
//                    networkClient.requestObject(urlSuffix: <#T##String#>, httpMethod: <#T##VOYNetworkClient.VOYHTTPMethod#>, completion: <#T##(Mappable?, Error?, URLRequest) -> Void#>)
        case .notApproved:
//                    networkClient.requestObject(urlSuffix: <#T##String#>, httpMethod: <#T##VOYNetworkClient.VOYHTTPMethod#>, completion: <#T##(Mappable?, Error?, URLRequest) -> Void#>)
        }
    }
    
}
