//
//  VOYReportListProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYReportListTableViewProvider: ISOnDemandTableViewInteractor {
    
    override init() {
        super.init(paginationCount: 20)
    }
    
    override func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        handler(["0","1", "2" , "3", "4"], nil)
    }
}
