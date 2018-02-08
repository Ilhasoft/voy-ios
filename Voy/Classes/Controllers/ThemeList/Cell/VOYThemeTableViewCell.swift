//
//  VOYThemeTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView
import ObjectMapper

class VOYThemeTableViewCell: RestBindTableViewCell {

    @IBOutlet var lbTheme:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.restBindFillView.layer.cornerRadius = 5
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func setupCell(with object: Any, at indexPath: IndexPath) {
        super.setupCell(with: object, at: indexPath)
        let theme = VOYTheme(JSON:self.object.JSON)!
        self.restBindFillView.backgroundColor = UIColor(hex: theme.color)
    }
    
}

