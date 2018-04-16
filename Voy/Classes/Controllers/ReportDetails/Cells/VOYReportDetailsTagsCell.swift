//
//  VOYReportDetailsTagsCell.swift
//  Voy
//
//  Created by Dielson Sales on 13/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import TagListView

class VOYReportDetailsTagsCell: UITableViewCell {

    @IBOutlet var viewTags: TagListView!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewTags.backgroundColor = UIColor.white
        viewTags.textColor = UIColor.white
        viewTags.selectedTextColor = UIColor.white
        viewTags.cornerRadius = 7
        viewTags.paddingY = 9
        viewTags.paddingX = 22
        viewTags.marginY = 13
    }

    func setTags(_ tags: [String], withColorHex colorHex: String) {
        let themeColor = UIColor(hex: colorHex)
        viewTags.tagBackgroundColor = themeColor
        viewTags.tagHighlightedBackgroundColor = themeColor
        viewTags.tagSelectedBackgroundColor = themeColor

        viewTags.removeAllTags()
        viewTags.addTags(tags)
    }
}
