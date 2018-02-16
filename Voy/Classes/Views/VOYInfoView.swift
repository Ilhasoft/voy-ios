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
    @IBOutlet var contentView:UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
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
    
    func setupWith(titleAndColor:[String:UIColor],messageAndColor:[String:UIColor]) {
        self.imgAvatar.kf.setImage(with: URL(string:VOYUser.activeUser()!.avatar))
        self.lbTitle.text = titleAndColor.keys.first!
        self.lbTitle.textColor = titleAndColor.values.first!
        self.lbMessage.text = messageAndColor.keys.first!
        self.lbMessage.textColor = messageAndColor.values.first!
    }

    
}

