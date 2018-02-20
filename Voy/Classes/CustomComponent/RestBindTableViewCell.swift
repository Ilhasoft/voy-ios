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

open class RestBindTableViewCell: UITableViewCell, ISOnDemandTableViewCell {
    
    @IBOutlet public var dataBindView:DataBindView!
    
    public var object:Map!
    
    override open func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    open func setupCell(with object: Any, at indexPath: IndexPath) {
        self.object = object as! Map
        dataBindView.fillFields(withObject:self.object.JSON)
    }
    
}
