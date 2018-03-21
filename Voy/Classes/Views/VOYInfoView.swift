//
//  VOYInfoView.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

@IBDesignable
class VOYInfoView: UIView {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "VOYInfoView", bundle: Bundle(for: VOYInfoView.self))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        self.addSubview(contentView)
    }
    
    func setupWith(titleAndColor: [String: UIColor], messageAndColor: [String: UIColor]) {
        guard let activeUser = VOYUser.activeUser() else { return }
        self.imgAvatar.kf.setImage(with: URL(string: activeUser.avatar))

        if let firstTitleAndColorKey = titleAndColor.keys.first {
            self.lbTitle.text = firstTitleAndColorKey
        }

        if let firstTitleAndColorValue = titleAndColor.values.first {
            self.lbTitle.textColor = firstTitleAndColorValue
        }

        if let firstMessageAndColorKey = messageAndColor.keys.first {
            self.lbMessage.text = firstMessageAndColorKey
        }

        if let firstMessageAndColorValue = messageAndColor.values.first {
            self.lbMessage.textColor = firstMessageAndColorValue
        }
    }
}
