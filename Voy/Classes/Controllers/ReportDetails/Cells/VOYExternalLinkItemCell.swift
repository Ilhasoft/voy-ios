//
//  VOYExternalLinkItemCell.swift
//  Voy
//
//  Created by Dielson Sales on 13/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYExternalLinkItemCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        textLabel?.textColor = UIColor.blue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLink(link: String) {
        textLabel?.text = link
    }
}
