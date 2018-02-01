//
//  VOYThemeTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYThemeTableViewCell: UITableViewCell {

    @IBOutlet var lbTheme:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension VOYThemeTableViewCell : ISOnDemandTableViewCell {
    func setupCell(with object: Any, at indexPath: IndexPath) {
        let text = object as! String
        self.lbTheme.text = text
    }
}
