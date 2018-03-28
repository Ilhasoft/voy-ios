//
//  VOYReportDetailsViewController.swift
//  Voy
//
//  Created by Dielson Sales on 27/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import TagListView
import ISScrollViewPageSwift
import AXPhotoViewer
import AVKit

class VOYReportDetailsViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewMedias: ISScrollViewPage!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var viewTags: TagListView!

    @IBOutlet var viewSeparator: UIView!
    @IBOutlet var btComments: UIButton!

    private var presenter: VOYReportDetailsPresenter!

    init(report: VOYReport) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        presenter = VOYReportDetailsPresenter(report: report, view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollViewMedias()
        setupTagsView()
        setupLocalization()
        presenter.onViewDidLoad()
    }

    // MARK: - Private methods

    private func setupScrollViewMedias() {
        scrollViewMedias.scrollViewPageType = .horizontally
        scrollViewMedias.scrollViewPageDelegate = self
        scrollViewMedias.setPaging(true)
    }

    private func setupTagsView() {
        viewTags.backgroundColor = UIColor.white
        viewTags.textColor = UIColor.white
        viewTags.selectedTextColor = UIColor.white
        viewTags.cornerRadius = 7
        viewTags.paddingY = 9
        viewTags.paddingX = 22
        viewTags.marginY = 13
    }

    private func setupLocalization() {
        btComments.setTitle(localizedString(.comment), for: .normal)
    }

    @IBAction
    func didTapCommentsButton(_ button: UIButton) {
        presenter.onTapCommentsButton()
    }
}

extension VOYReportDetailsViewController: VOYReportDetailsContract {

    func setupText(title: String, date: String, description: String, tags: [String]) {
        lbTitle.text = title
        lbDate.text = date
        lbDescription.text = description
        viewTags.addTags(tags)
    }

    func setThemeColor(themeColorHex: String) {
        let themeColor = UIColor(hex: themeColorHex)
        pageControl.currentPageIndicatorTintColor = themeColor
        pageControl.pageIndicatorTintColor = themeColor.withAlphaComponent(0.5)
        lbTitle.textColor = themeColor
        lbDate.textColor = themeColor

        viewTags.tagBackgroundColor = themeColor
        viewTags.tagHighlightedBackgroundColor = themeColor
        viewTags.tagSelectedBackgroundColor = themeColor
    }

    func setMedias(_ medias: [VOYMedia]) {
        pageControl.numberOfPages = medias.count
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
    }

    func navigateToPictureScreen(image: UIImage) {
        let dataSource = PhotosDataSource(photos: [Photo(image: image)])
        let photosViewController = PhotosViewController(dataSource: dataSource)
        present(photosViewController, animated: true, completion: nil)
    }

    func navigateToVideoScreen(videoURL: URL) {
        let playerController = AVPlayerViewController()
        playerController.player = AVPlayer(url: videoURL)
        playerController.player?.play()
        present(playerController, animated: true, completion: nil)
    }

    func navigateToCommentsScreen(report: VOYReport) {
        navigationController?.pushViewController(VOYCommentViewController(report: report), animated: true)
    }

    func setCommentButtonEnabled(_ enabled: Bool) {
        viewSeparator.isHidden = !enabled
        btComments.isHidden = !enabled
    }
}

extension VOYReportDetailsViewController: ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(_ scrollViewPage: ISScrollViewPage, index: Int) {
        pageControl.currentPage = index
    }
}

extension VOYReportDetailsViewController: VOYPlayMediaViewDelegate {
    func mediaDidTap(mediaView: VOYPlayMediaView) {
        presenter.onTapImage(image: mediaView.imgView.image)
    }

    func videoDidTap(mediaView: VOYPlayMediaView, url: URL, showInFullScreen: Bool) {
        presenter.onTapVideo(videoURL: url)
    }
}
