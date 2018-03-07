//
//  VOYMockAddReportRepository.swift
//  Voy
//
//  Created by Pericles Jr on 07/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYMockAddReportRepository: VOYAddReportDataSource {
    var hasNetwork: Bool = false
    
    func setNetwork(hasNetwork: Bool) {
        self.hasNetwork = hasNetwork
    }
    
    func save(report: VOYReport, completion: @escaping (Error?, Int?) -> Void) {
        if hasNetwork {
            completion(nil, 1234567)
        } else {
            completion(nil, nil)
        }
    }
    

}
