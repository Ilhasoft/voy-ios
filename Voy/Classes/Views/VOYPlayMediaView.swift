//
//  VOYPlayMediaView.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DataBindSwift
import AVFoundation
import Player
import Alamofire
import NVActivityIndicatorView

enum VOYMediaType:String {
    case image = "image"
    case video = "video"
}

protocol VOYPlayMediaViewDelegate {
    func mediaDidTap(mediaView:VOYPlayMediaView)
    func videoDidTap(mediaView:VOYPlayMediaView, url:URL, showInFullScreen:Bool)
}

class VOYPlayMediaView: UIView, NVActivityIndicatorViewable {

    @IBOutlet var contentView:DataBindView!
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var imgPlayIcon:UIImageView!
    @IBOutlet var activityView:NVActivityIndicatorView!
    
    var fullScreen = false
    var delegate:VOYPlayMediaViewDelegate?
    var media:VOYMedia!
    var videoURL:URL?
    
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
        if self.media.media_type == VOYMediaType.image.rawValue {
            self.delegate?.mediaDidTap(mediaView:self)
        }
    }

    func setup(media:VOYMedia) {
        self.media = media
        
        switch self.media.media_type {
        case VOYMediaType.image.rawValue:
            self.imgPlayIcon.isHidden = true
            self.activityView.isHidden = true
            self.imgView.isHidden = false
            self.imgView.kf.setImage(with: URL(string:self.media.file))
            break
        case VOYMediaType.video.rawValue:
            self.activityView.isHidden = false
            self.activityView.startAnimating()
            VOYMediaDownloadManager.shared.download(url: self.media.file, completion: { (url) in
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
                
                guard let url = url else {return}
                let thumb = ISVideoUtil.generateThumbnail(url)
                self.imgView.image = thumb
                self.imgPlayIcon.isHidden = false
                self.videoURL = url
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.videoDidTap))
                self.contentView.addGestureRecognizer(tap)
            })
            
            break
        default:
            break
        }
        
    }
    
    @objc func videoDidTap() {
        fullScreen = !fullScreen
        self.delegate?.videoDidTap(mediaView: self, url:self.videoURL!, showInFullScreen: fullScreen)
    }
    
}

