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
    func removeMediaButtonDidTap(mediaView:VOYAddMediaView)
}

class VOYAddMediaView: UIView {

    @IBOutlet weak var btRemove: UIButton!
    @IBOutlet weak var imgViewPlusIcon: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var contentView:UIView!
    
    var cameraData:VOYCameraData!
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
        imgView.layer.cornerRadius = 7
        contentView.frame = bounds
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
        addSubview(contentView)
    }
    
    func setupWithMedia(cameraData:VOYCameraData) {
        self.cameraData = cameraData
        self.imgView.isHidden = false
        self.imgViewPlusIcon.isHidden = true
        self.btRemove.isHidden = false
        
        if cameraData.type == .image {
            self.imgView.image = cameraData.image!
        }else if cameraData.type == .video {
            self.imgView.image = ISVideoUtil.generateThumbnail(cameraData.path!)
        }
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer) {
        let mediaView = gestureRecognizer.view as! VOYAddMediaView
        self.delegate?.mediaViewDidTap(mediaView: mediaView)
    }

    @IBAction func btRemoveTapped(_ sender: Any) {
        self.delegate?.removeMediaButtonDidTap(mediaView: self)
        self.btRemove.isHidden = true
        self.imgView.image = nil
        self.imgViewPlusIcon.isHidden = false
    }
    
}
