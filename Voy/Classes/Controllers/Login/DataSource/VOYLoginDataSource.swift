//
//  VOYLoginDataSource.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYLoginDataSource {
    func login(username:String, password:String, completion:@escaping(_ user:VOYUser?, _ error:Error?) -> Void)
    func getUserData(authToken:String, completion:@escaping(_ user:VOYUser?, _ error:Error?) -> Void)
}
