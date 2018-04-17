//
//  VOYReportDetailsHeaderCell.swift
//  Voy
//
//  Created by Dielson Sales on 12/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISScrollViewPageSwift

class VOYReportDetailsHeaderCell: UITableViewCell {

    @IBOutlet var scrollViewMedias: ISScrollViewPage!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbDescription: UILabel!

    var presenter: VOYReportDetailsPresenter?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        scrollViewMedias.scrollViewPageDelegate = self
        setupScrollViewMedias()
    }

    func setup(with viewModel: VOYReportDetailsViewModel) {
        lbTitle.text = viewModel.title
        lbDate.text = viewModel.date
        lbDescription.text = viewModel.description

        let themeColor = UIColor(hex: viewModel.themeColorHex)
        pageControl.currentPageIndicatorTintColor = themeColor
        pageControl.pageIndicatorTintColor = themeColor.withAlphaComponent(0.5)
        setMedias(viewModel.medias, viewModel.cameraDataList)
        setThemeColor(colorHex: viewModel.themeColorHex)
    }

    private func setThemeColor(colorHex: String) {
        let themeColor = UIColor(hex: colorHex)
        pageControl.currentPageIndicatorTintColor = themeColor
        pageControl.pageIndicatorTintColor = themeColor.withAlphaComponent(0.5)
        lbTitle.textColor = themeColor
        lbDate.textColor = themeColor
    }

    private func setupScrollViewMedias() {
        scrollViewMedias.scrollViewPageType = .horizontally
        scrollViewMedias.scrollViewPageDelegate = self
        scrollViewMedias.setPaging(true)
    }

    private func setMedias(_ medias: [VOYMedia], _ cameraDataList: [VOYCameraData]) {
        pageControl.numberOfPages = medias.count + cameraDataList.count
        for media in medias {
            DispatchQueue.main.async {
                let mediaPlayView = VOYPlayMediaView(
                    frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 161)
                )
                mediaPlayView.setup(media: media)
                mediaPlayView.delegate = self
                self.scrollViewMedias.addCustomView(mediaPlayView)
            }
        }
        for cameraData in cameraDataList {
            DispatchQueue.main.async {
                let mediaPlayView = VOYPlayMediaView(
                    frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 161)
                )
                mediaPlayView.setup(cameraData: cameraData)
                mediaPlayView.delegate = self
                self.scrollViewMedias.addCustomView(mediaPlayView)
            }
        }
    }
}

extension VOYReportDetailsHeaderCell: ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(_ scrollViewPage: ISScrollViewPage, index: Int) {
        pageControl.currentPage = index
    }
}

extension VOYReportDetailsHeaderCell: VOYPlayMediaViewDelegate {
    func mediaDidTap(mediaView: VOYPlayMediaView) {
        presenter?.onTapImage(image: mediaView.imgView.image)
    }

    func videoDidTap(mediaView: VOYPlayMediaView, url: URL, showInFullScreen: Bool) {
        presenter?.onTapVideo(videoURL: url)
    }
}
