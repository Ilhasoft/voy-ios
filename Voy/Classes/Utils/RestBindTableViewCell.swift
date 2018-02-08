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

class RestBindTableViewCell: UITableViewCell {
    
    @IBOutlet public var restBindFillView:RestBindFillView!
    
    var object:Map!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension RestBindTableViewCell : ISOnDemandTableViewCell {
    func setupCell(with object: Any, at indexPath: IndexPath) {
        self.object = object as! Map
        restBindFillView.fetchedObject = self.object
        restBindFillView.fillFields()
    }
}
