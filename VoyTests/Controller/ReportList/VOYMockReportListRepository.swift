//
//  VOYMockReportListRepository.swift
//  VoyTests
//
//  Created by Pericles Jr on 19/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
@testable import Voy

class VOYMockReportListRepository: VOYReportListDataSource {
    
    func getReportCount(themeId: Int,
                        status: VOYReportStatus,
                        mapper: Int,
                        completion: @escaping (Int?, Error?) -> Void) {
        completion(10, nil)
    }
}
