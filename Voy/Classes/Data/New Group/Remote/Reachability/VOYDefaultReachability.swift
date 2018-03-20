//
//  VOYReachabilityImpl.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYDefaultReachability: VOYReachability {

    private let manager = NetworkReachabilityManager()!

    func hasNetwork() -> Bool {
        return manager.isReachable
    }
}
