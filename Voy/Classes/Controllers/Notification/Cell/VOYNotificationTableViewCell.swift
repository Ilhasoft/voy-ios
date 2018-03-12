//
//  VOYNotificationTableViewCell.swift
//  Voy
//
//  Created by Pericles Jr on 08/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYNotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tvNotificationBody: UITextView!
    
    static let identifier = String(describing: VOYNotificationTableViewCell.classForCoder())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with text: String) {
        self.tvNotificationBody.text = text
    }
}
