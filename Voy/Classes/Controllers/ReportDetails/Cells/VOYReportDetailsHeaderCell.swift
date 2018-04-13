//
//  VOYReportDetailsHeaderCell.swift
//  Voy
//
//  Created by Dielson Sales on 12/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportDetailsHeaderCell: UITableViewCell {

    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        lbDescription.text = "For example, if you were displaying an email message in each cell, you might have 4"
//        + "unique layouts: messages with just a subject, messages with a subject and a body, messages with a subject"
//        + "and a photo attachment, and messages with a subject, body, and photo attachment. Each layout has completely"
//        + " different constraints required to achieve it, so once the cell is initialized and the constraints are added"
//        + " for one of these cell types, the cell should get a unique reuse identifier specific to that cell type."
//        + " This means when you dequeue a cell for reuse, the constraints have already been added and are ready to go"
//        + " for that cell type."
    }

    func setup(with viewModel: VOYReportDetailsViewModel) {
        lbTitle.text = viewModel.title
        lbDate.text = viewModel.date
        lbDescription.text = viewModel.description
    }
}
