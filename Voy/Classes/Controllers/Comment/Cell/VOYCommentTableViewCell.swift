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

protocol VOYCommentTableViewCellDelegate: AnyObject {
    func btOptionsDidTap(commentId: Int)
}

class VOYCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var btOptions: UIButton!

    var comment: VOYComment?

    weak var delegate: VOYCommentTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    @IBAction func btOptionsTapped(_ sender: Any) {
        guard let delegate = self.delegate, let commentId = comment?.id else { return }
        delegate.btOptionsDidTap(commentId: commentId)
    }

    func set(comment: VOYComment) {
        self.comment = comment
        lbName.text = comment.createdBy.username
        lbComment.text = comment.text

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        if let date = dateFormatter.date(from: comment.createdOn) {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MMM"
            dateFormatter2.dateStyle = .medium
            lbDate.text = dateFormatter2.string(from: date)
        }

        var activeUserName = ""
        // comment.createdBy.avatar
        if let username = VOYUser.activeUser()?.username {
            activeUserName = username
        }
        if let username = self.lbName.text, username != activeUserName {
            self.btOptions.isHidden = true
        } else {
            self.btOptions.isHidden = false
        }
    }

    func set(image: UIImage) {
        imgAvatar.image = image
    }
}
