//
//  VOYPlayMediaView.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import RestBind

protocol VOYPlayMediaViewDelegate {
    func mediaDidTap()
}

class VOYPlayMediaView: UIView {

    @IBOutlet var contentView:RestBindFillView!
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var imgPlayIcon:UIImageView!
    
    var delegate:VOYPlayMediaViewDelegate?
    var media:VOYMedia! {
        didSet {
            print(media)
            contentView.fillFields(withObject: media.map())
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "VOYPlayMediaView", bundle: Bundle(for: VOYPlayMediaView.self))
        nib.instantiate(withOwner: self, options: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.addGestureRecognizer(tapGesture)
        contentView.frame = bounds
        self.addSubview(contentView)        
    }
    
    @objc func viewDidTap() {
        self.delegate?.mediaDidTap()
    }

    func setup(media:VOYMedia) {
        self.media = media
    }
    
}
