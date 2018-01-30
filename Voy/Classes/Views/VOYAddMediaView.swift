//
//  VOYAddMediaView.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYAddMediaViewDelegate {
    func mediaViewDidTap(mediaView:VOYAddMediaView)
}

class VOYAddMediaView: UIView {

    @IBOutlet weak var btRemove: UIButton!
    @IBOutlet weak var imgViewPlusIcon: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var contentView:UIView!
    
    var delegate:VOYAddMediaViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "VOYAddMediaView", bundle: Bundle(for: VOYAddMediaView.self))
        nib.instantiate(withOwner: self, options: nil)
        contentView.layer.cornerRadius = 7
        contentView.frame = bounds
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
        addSubview(contentView)
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer) {
        let mediaView = gestureRecognizer.view as! VOYAddMediaView
        print(mediaView)
        self.delegate?.mediaViewDidTap(mediaView: mediaView)
    }

    @IBAction func btRemoveTapped(_ sender: Any) {
        
    }
    
}
