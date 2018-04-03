//
//  RestBindTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ObjectMapper
import ISOnDemandTableView
import DataBindSwift

open class DataBindOnDemandTableViewCell: UITableViewCell, ISOnDemandTableViewCell {

    @IBOutlet public var dataBindView: DataBindView!

    public var object: Map!

    open func setupCell(with object: Any, at indexPath: IndexPath) {
        if let objectAsMap = object as? Map {
            self.object = objectAsMap
            print(self.object.JSON)
            dataBindView.fillFields(withObject: self.object.JSON)
        }
    }
}
