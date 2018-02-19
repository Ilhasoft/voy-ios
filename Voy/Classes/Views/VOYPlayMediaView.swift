//
//  VOYPlayMediaView.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import RestBind
import PlayerKit
import AVFoundation

enum VOYMediaType:String {
    case image = "image"
    case video = "video"
}

protocol VOYPlayMediaViewDelegate {
    func mediaDidTap(mediaView:VOYPlayMediaView)
}

class VOYPlayMediaView: UIView {

    @IBOutlet var contentView:RestBindFillView!
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var imgPlayIcon:UIImageView!
    
    var delegate:VOYPlayMediaViewDelegate?
    var media:VOYMedia!
    var player:RegularPlayer!
    
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
        player = RegularPlayer()
    }
    
    @objc func viewDidTap() {
        if self.media.media_type == VOYMediaType.image.rawValue {
            self.delegate?.mediaDidTap(mediaView:self)
        }
    }

    func setup(media:VOYMedia) {
        self.media = media
        
        switch self.media.media_type {
        case VOYMediaType.image.rawValue:
            self.imgView.isHidden = false
            self.imgView.kf.setImage(with: URL(string:self.media.file))
            break
        case VOYMediaType.video.rawValue:
            self.imgView.isHidden = true
            contentView.addSubview(player.view)
            player.set(AVURLAsset(url: URL(string:self.media.file)!))
            player.play()
            break
        default:
            break
        }
        
    }
    
}

