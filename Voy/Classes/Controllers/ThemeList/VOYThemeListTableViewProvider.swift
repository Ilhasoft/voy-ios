//
//  VOYThemeListTableViewProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYThemeListTableViewProvider: ISOnDemandTableViewInteractor {

    override init() {
        super.init(paginationCount: 20)
    }
    
    override func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        handler(["Sanitation problems","Trash", "Os índices do aquecimento global alcançam recordes de 1.000 anos", "Rivereiet, conseadipiscing elit"],nil)
    }
    
}
