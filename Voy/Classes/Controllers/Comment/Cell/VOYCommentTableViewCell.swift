//
//  VOYCommentTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

protocol VOYCommentTableViewCellDelegate {
    func btOptionsDidTap(cell:VOYCommentTableViewCell)
}

class VOYCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var btOptions: UIButton!
    
    var delegate:VOYCommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func btOptionsTapped(_ sender: Any) {
        delegate?.btOptionsDidTap(cell: self)
    }
    
    
}

extension VOYCommentTableViewCell : ISOnDemandTableViewCell {
    func setupCell(with object: Any, at indexPath: IndexPath) {
        self.imgAvatar.image = #imageLiteral(resourceName: "avatar4")
        self.lbComment.text = object as? String
    }
}
