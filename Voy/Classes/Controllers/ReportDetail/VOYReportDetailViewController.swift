//
//  VOYReportDetailViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISScrollViewPageSwift
import TagListView
import DataBindSwift
import AXPhotoViewer
import MediaPlayer
import AVKit

class VOYReportDetailViewController: UIViewController {

    @IBOutlet weak var scrollViewMedias: DataBindScrollViewPageSwift!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lbTitle: DataBindLabel!
    @IBOutlet weak var lbDate: DataBindLabel!
    @IBOutlet weak var lbDescription: DataBindLabel!
    @IBOutlet weak var viewTags: TagListView!
    @IBOutlet weak var btComment: UIButton!
    @IBOutlet weak var dataBindView: DataBindView!
    @IBOutlet weak var separatorView: UIView!

    var report: VOYReport!
    var presenter: VOYReportDetailPresenter!

    init(report: VOYReport) {
        self.report = report
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = []

        scrollViewMedias.scrollViewPageType = .horizontally
        scrollViewMedias.scrollViewPageDelegate = self
        scrollViewMedias.setPaging(true)

        dataBindView.delegate = self
        dataBindView.fillFields(withObject: report.toJSON())
        setupNavigationItem()
        setupViewTags()
        setupColors()
        setupLocalization()

        presenter = VOYReportDetailPresenter(view: self, report: self.report)
        presenter.onViewDidLoad()
    }

    func setupViewTags() {
        if let tags = self.report.tags {
            self.viewTags.addTags(tags)
        }
    }

    func setupNavigationItem() {
        guard let activeUser = VOYUser.activeUser() else { return }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        let barButtonItemOptions = UIBarButtonItem(
            image: #imageLiteral(resourceName: "combinedShape").withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(onItemOptionsTapped)
        )
        let barButtonItemIssue = UIBarButtonItem(
            image: #imageLiteral(resourceName: "issue").withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(showIssue)
        )
        let barButtonItemShare = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.action,
            target: self,
            action: #selector(btShareTapped)
        )
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.kf.setImage(with: URL(string: activeUser.avatar))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 31).isActive = true

        self.navigationItem.title = localizedString(.report)

        var buttonItens = [barButtonItemOptions, barButtonItemIssue]

        if self.report.lastNotification == nil
            || (self.report.lastNotification != nil && self.report.lastNotification.isEmpty) {
            buttonItens.remove(at: 1)
        }

        if let status = self.report.status, status == VOYReportStatus.approved.rawValue {
            buttonItens.remove(at: 0)
        }

        if let reportStatus = report.status, reportStatus == VOYReportStatus.approved.rawValue {
            buttonItens.append(barButtonItemShare)
        }

        self.navigationItem.rightBarButtonItems = buttonItens
    }

    @objc func showIssue() {
        let alertInfoController = VOYAlertViewController(
            title: localizedString(.issuesReported),
            message: self.report.lastNotification,
            buttonNames: [localizedString(.editReport), localizedString(.close)]
        )
        alertInfoController.delegate = self
        alertInfoController.show(true, inViewController: self)
    }

    func setupScrollViewMedias(media: VOYMedia) {
        let mediaPlayView = VOYPlayMediaView(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 161)
        )
        mediaPlayView.setup(media: media)
        mediaPlayView.delegate = self
        scrollViewMedias.addCustomView(mediaPlayView)
    }

    @objc func removePlayer() {
        UIView.transition(
            with: self.view,
            duration: 0.5,
            options: UIViewAnimationOptions.transitionCrossDissolve,
            animations: {
                self.navigationController?.view.viewWithTag(130)?.removeFromSuperview()
            },
            completion: nil
        )
    }

    @objc private func onItemOptionsTapped() {
        presenter.onOptionsButtonTapped()
    }

    @objc private func btShareTapped() {
        presenter.onShareButtonTapped()
    }

    @IBAction func btCommentTapped(_ sender: Any) {
        presenter.onCommentButtonTapped()
    }

    private func setupColors() {
        if let currentTheme = VOYTheme.activeTheme(), let colorHex = currentTheme.color {
            let themeColor = UIColor(hex: colorHex)
            lbTitle.textColor = themeColor
            lbDate.textColor = themeColor
            viewTags.tagBackgroundColor = themeColor
            pageControl.currentPageIndicatorTintColor = themeColor
            pageControl.pageIndicatorTintColor = themeColor.withAlphaComponent(0.5)
        }
    }

    // MARK: - Private methods

    private func setupLocalization() {
        btComment.setTitle(localizedString(.comment), for: .normal)
    }
}

extension VOYReportDetailViewController: VOYReportDetailContract {

    func navigateToCommentsScreen(report: VOYReport) {
        self.navigationController?.pushViewController(VOYCommentViewController(report: report), animated: true)
    }

    func shareText(_ string: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [string],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }

    func showPictureScreen(image: UIImage) {
        let dataSource = PhotosDataSource(photos: [Photo(image: image)])
        let photosViewController = PhotosViewController(dataSource: dataSource)
        present(photosViewController, animated: true, completion: nil)
    }

    func showVideoScreen(videoURL: URL) {
        let playerController = AVPlayerViewController()
        playerController.player = AVPlayer(url: videoURL)
        playerController.player?.play()
        present(playerController, animated: true, completion: nil)
    }

    func showActionSheet() {
        let actionSheetViewController = VOYActionSheetViewController(
            buttonNames: [localizedString(.editReport)],
            icons: nil
        )
        actionSheetViewController.delegate = self
        actionSheetViewController.show(true, inViewController: self)
    }

    func navigateToEditReportScreen(report: VOYReport) {
        self.navigationController?.pushViewController(
            VOYAddReportAttachViewController(report: report),
            animated: true
        )
    }

    func setCommentButtonEnabled(_ enabled: Bool) {
        btComment.isHidden = !enabled
        separatorView.isHidden = !enabled
    }
}

extension VOYReportDetailViewController: ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(_ scrollViewPage: ISScrollViewPage, index: Int) {
        self.pageControl.currentPage = index
    }
}

extension VOYReportDetailViewController: VOYActionSheetViewControllerDelegate {
    func cancelButtonDidTap(actionSheetViewController: VOYActionSheetViewController) {
        actionSheetViewController.close()
    }

    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        actionSheetViewController.close()
        self.navigationController?.pushViewController(
            VOYAddReportAttachViewController(report: self.report),
            animated: true
        )
    }
}

extension VOYReportDetailViewController: VOYAlertViewControllerDelegate {
    func buttonDidTap(alertController: VOYAlertViewController, button: UIButton, index: Int) {
        alertController.close()
        switch index {
        case 0:
            presenter.onTapEditReport()
        case 1:
            break
        default:
            break
        }
    }
}

extension VOYReportDetailViewController: DataBindViewDelegate {
    func didFillAllComponents(JSON: [String: Any]) {
    }

    func willFill(component: Any, value: Any) -> Any? {
        if let component = component as? UILabel {
            if component == self.lbDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = localizedString(.dateFormat)
                if let dateString = value as? String {
                    let date = dateFormatter.date(from: dateString)
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "MMM"
                    dateFormatter2.dateStyle = .medium
                    if let date = date { lbDate.text = dateFormatter2.string(from: date) }
                }
                return nil
            }

        } else if component is UIScrollView {
            if let values = value as? [[String: Any]] {
                for mediaObject in values {
                    if let media = VOYMedia(JSON: mediaObject) {
                        setupScrollViewMedias(media: media)
                    }
                }
                self.pageControl.numberOfPages = scrollViewMedias.views?.count ?? 0
            }
        }
        return value
    }

    func didFill(component: Any, value: Any) {
    }

    func willSet(component: Any, value: Any) -> Any? {
        return value
    }

    func didSet(component: Any, value: Any) {
    }
}

extension VOYReportDetailViewController: VOYPlayMediaViewDelegate {
    func mediaDidTap(mediaView: VOYPlayMediaView) {
        presenter.onTapImage(image: mediaView.imgView.image)
    }

    func videoDidTap(mediaView: VOYPlayMediaView, url: URL, showInFullScreen: Bool) {
        presenter.onTapVideo(videoURL: url)
    }
}
