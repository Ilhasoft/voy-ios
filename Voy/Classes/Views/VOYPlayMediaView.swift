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
import Alamofire
import NVActivityIndicatorView

enum VOYMediaType: String {
    case image
    case video
}

protocol VOYPlayMediaViewDelegate: class {
    func mediaDidTap(mediaView: VOYPlayMediaView)
    func videoDidTap(mediaView: VOYPlayMediaView, url: URL, showInFullScreen: Bool)
}

class VOYPlayMediaView: UIView, NVActivityIndicatorViewable {

    @IBOutlet var contentView: DataBindView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgPlayIcon: UIImageView!
    @IBOutlet var activityView: NVActivityIndicatorView!

    var fullScreen = false
    weak var delegate: VOYPlayMediaViewDelegate?
    var mediaType: VOYMediaType?
    var videoURL: URL?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        if let mediaType = self.mediaType, mediaType == .image {
            self.delegate?.mediaDidTap(mediaView: self)
        }
    }

    func setup(media: VOYMedia) {
        switch media.media_type {
        case VOYMediaType.image.rawValue:
            self.imgPlayIcon.isHidden = true
            self.activityView.isHidden = true
            self.imgView.isHidden = false
            self.mediaType = .image
            self.imgView.kf.setImage(with: URL(string: media.file))
        case VOYMediaType.video.rawValue:
            self.activityView.isHidden = false
            self.mediaType = .video
            self.activityView.startAnimating()
            if let thumbnail = media.thumbnail {
                self.imgView.kf.setImage(with: URL(string: thumbnail))
            } else {
                print("video sem thumbnail")
            }
            VOYMediaDownloadManager.shared.download(url: media.file, completion: { (url) in
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
                guard let url = url else { return }
                let thumb = ISVideoUtil.generateThumbnail(url)
                self.imgView.image = thumb
                self.imgPlayIcon.isHidden = false
                self.videoURL = url
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.videoDidTap))
                self.contentView.addGestureRecognizer(tap)
            })
        default:
            break
        }
    }

    func setup(cameraData: VOYCameraData) {
        guard let cameraDataType = cameraData.type else { return }
        switch cameraDataType {
        case VOYMediaType.image:
            self.mediaType = .image
            self.imgPlayIcon.isHidden = true
            self.activityView.isHidden = true
            self.imgView.isHidden = false
            if let image = cameraData.image {
                self.imgView.image = image
            } else if let imageFileName = cameraData.fileName,
                let urlPath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(imageFileName) {
                self.imgView.image = UIImage(contentsOfFile: urlPath)
            }
        case VOYMediaType.video:
            self.mediaType = .video
            self.activityView.isHidden = false
            guard let fileName = cameraData.fileName,
                let videoFilePath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) else { return }
            self.videoURL = URL(fileURLWithPath: videoFilePath)
            if let thumbnail = cameraData.thumbnail {
                self.imgView.image = thumbnail
            } else if let thumbnailFileName = cameraData.thumbnailFileName,
                let urlPath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(thumbnailFileName) {
                self.imgPlayIcon.isHidden = false
                self.imgView.image = UIImage(contentsOfFile: urlPath)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.videoDidTap))
                self.contentView.addGestureRecognizer(tap)
            }
        }
    }

    @objc func videoDidTap() {
        fullScreen = !fullScreen
        if let videoURL = self.videoURL, let mediaType = self.mediaType, mediaType == .video {
            self.delegate?.videoDidTap(mediaView: self, url: videoURL, showInFullScreen: fullScreen)
        }
    }
}
