//
//  VOYThemeTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DataBindSwift

open class VOYThemeTableViewCell: DataBindOnDemandTableViewCell {

    @IBOutlet var lbTheme: UILabel!
    
    static var nibName: String {
        return "VOYThemeTableViewCell"
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.dataBindView.layer.cornerRadius = 5
        self.selectionStyle = .none
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override open func setupCell(with object: Any, at indexPath: IndexPath) {
        super.setupCell(with: object, at: indexPath)
        if let theme = VOYTheme(JSON: self.object.JSON) {
            self.dataBindView.backgroundColor = UIColor(hex: theme.color)
        }
    }
}
