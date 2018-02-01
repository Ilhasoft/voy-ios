//
//  VOYLinkTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 31/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYLinkTableViewCellDelegate {
    func removeButtonDidTap(cell:VOYLinkTableViewCell)
    func linkDidTap(url:String, cell:VOYLinkTableViewCell)
}

class VOYLinkTableViewCell: UITableViewCell {

    @IBOutlet var lbLink:UILabel!
    @IBOutlet var btRemove:UIButton!
    
    var delegate:VOYLinkTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(data:String) {
        self.lbLink.text = data
    }
    
    @IBAction func btRemoveTapped() {
        delegate?.removeButtonDidTap(cell: self)
    }
    
}
