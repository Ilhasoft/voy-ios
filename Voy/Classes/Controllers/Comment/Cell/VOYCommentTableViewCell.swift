//
//  VOYCommentTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView
import DataBindSwift

protocol VOYCommentTableViewCellDelegate: class {
    func btOptionsDidTap(commentId: Int)
}

class VOYCommentTableViewCell: DataBindOnDemandTableViewCell {

    @IBOutlet weak var imgAvatar: DataBindImageView!
    @IBOutlet weak var lbName: DataBindLabel!
    @IBOutlet weak var lbDate: DataBindLabel!
    @IBOutlet weak var lbComment: DataBindLabel!
    @IBOutlet weak var btOptions: UIButton!
    
    var cellJSON: [String: Any]?
    
    weak var delegate: VOYCommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.selectionStyle = .none
        self.dataBindView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func btOptionsTapped(_ sender: Any) {
        guard let delegate = self.delegate, let commentId = cellJSON!["id"] as? Int else { return }
        delegate.btOptionsDidTap(commentId: commentId)
    }
}

extension VOYCommentTableViewCell: DataBindViewDelegate {
    func didFillAllComponents(JSON: [String: Any]) {
        self.cellJSON = JSON
        if let username = self.lbName.text, username != VOYUser.activeUser()!.username {
            self.btOptions.isHidden = true
        } else {
            self.btOptions.isHidden = false
        }
    }

    func willFill(component: Any, value: Any) -> Any? {
        if let component = component as? UILabel {
            if component == self.lbDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                if let dateString = value as? String {
                    let date = dateFormatter.date(from: dateString)
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "MMM"
                    dateFormatter2.dateStyle = .medium
                    lbDate.text = dateFormatter2.string(from: date!)
                }
                return nil
            }
        }
        return value
    }

    func didFill(component: Any, value: Any) {
    }
    
    func willSet(component: Any, value: Any) -> Any? {
        return value
    }
    
    func didSet(component: Any, value: Any) {
    }
}
