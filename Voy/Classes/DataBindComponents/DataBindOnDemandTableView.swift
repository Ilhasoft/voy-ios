//
//  RestBindTableViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

open class DataBindOnDemandTableView: ISOnDemandTableView {

    @IBInspectable var apiURL:String?
    @IBInspectable var endPoint:String!
    @IBInspectable var keyPath:String?
    
    private var configuration:DataBindRestConfiguration!
    
    public func getConfiguration() -> DataBindRestConfiguration {
        configuration = DataBindRestConfiguration()
        configuration.apiURL = apiURL
        configuration.endPoint = endPoint
        configuration.keyPath = keyPath
        return configuration
    }
    
}
