//
//  VOYCommentTableViewProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYCommentTableViewProvider: ISOnDemandTableViewInteractor {

    override init() {
        super.init(paginationCount: 20)
    }
    
    override func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        handler(["KOPAJA - Koperasi Angkutan Jakarta, or in English Jakarta Transportation Cooperation is a public transportation service in Jakarta. Many people in Jakarta use this transportation for commuting to the workplace from home, or vice versa. Besides providing benefits, KOPAJA has a bad impact on respiratory health from it's emissions. KOPAJA must be demolished because the average age of KOPAJA armada is above 10 Years, and is using outdated technology.",
                 "Sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
                 "I know Right!"],nil)
    }
    
}
