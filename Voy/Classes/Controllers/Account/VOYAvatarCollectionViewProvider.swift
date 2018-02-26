//
//  VOYAvatarCollectionViewProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandCollectionView

class VOYAvatarCollectionViewProvider : ISOnDemandCollectionViewInteractor {
    init() {super.init(pagination: 300)}
    
    override func fetchObjects(forPage: Int, completion: @escaping (([Any]?, Error?) -> Void)) {
        var avatarList = [UIImage]()
        for i in 1...25 {
            avatarList.append(UIImage(named:"ic_avatar\(i)")!)
        }
        completion(avatarList,nil)
    }
}
