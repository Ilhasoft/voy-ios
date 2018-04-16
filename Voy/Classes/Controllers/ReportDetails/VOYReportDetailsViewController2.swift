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

class VOYReportDetailsViewController2: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewMedias: ISScrollViewPage!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var viewTags: TagListView!

    @IBOutlet var viewSeparator: UIView!
    @IBOutlet var btComments: UIButton!

    init(report: VOYReport) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTagsView()
    }

    // MARK: - Private methods

//    private func setupTagsView() {
//        viewTags.backgroundColor = UIColor.white
//        viewTags.textColor = UIColor.white
//        viewTags.selectedTextColor = UIColor.white
//        viewTags.cornerRadius = 7
//        viewTags.paddingY = 9
//        viewTags.paddingX = 22
//        viewTags.marginY = 13
//    }

//    private func showActionSheet() {
//        let actionSheetViewController = VOYActionSheetViewController(
//            buttonNames: [localizedString(.editReport)],
//            icons: nil
//        )
//        actionSheetViewController.delegate = self
//        actionSheetViewController.show(true, inViewController: self)
//    }

    // MARK: - Button Actions

    @objc
    func didTapShareButton() {
    }

    @objc
    func didTapIssueButton() {
    }

    @objc
    func didTapOptionsButton() {
    }
}

extension VOYReportDetailsViewController2 {

//    func setupText(title: String, date: String, description: String, tags: [String], commentsCount: Int) {
//        lbTitle.text = title
//        lbDate.text = date
//        lbDescription.text = description
//        viewTags.addTags(tags)
//        btComments.setTitle("\(localizedString(.comments)) (\(commentsCount))", for: .normal)
//    }

//    func setThemeColor(themeColorHex: String) {
//        let themeColor = UIColor(hex: themeColorHex)
//        pageControl.currentPageIndicatorTintColor = themeColor
//        pageControl.pageIndicatorTintColor = themeColor.withAlphaComponent(0.5)
//        lbTitle.textColor = themeColor
//        lbDate.textColor = themeColor

//        viewTags.tagBackgroundColor = themeColor
//        viewTags.tagHighlightedBackgroundColor = themeColor
//        viewTags.tagSelectedBackgroundColor = themeColor
//    }

    func setupNavigationButtons(avatarURL: URL, lastNotification: String?, showOptions: Bool, showShare: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        let barButtonItemOptions = UIBarButtonItem(
            image: #imageLiteral(resourceName: "combinedShape").withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapOptionsButton)
        )
        let barButtonItemIssue = UIBarButtonItem(
            image: #imageLiteral(resourceName: "issue").withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapIssueButton)
        )
        let barButtonItemShare = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.action,
            target: self,
            action: #selector(didTapShareButton)
        )
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.kf.setImage(with: avatarURL)
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 31).isActive = true

        self.navigationItem.title = localizedString(.report)

        var buttonItens = [barButtonItemOptions, barButtonItemIssue]

        if isEmptyOrNil(string: lastNotification) {
            buttonItens.remove(at: 1)
        }

        if !showOptions {
            buttonItens.remove(at: 0)
        }

        if showShare {
            buttonItens.append(barButtonItemShare)
        }

        self.navigationItem.rightBarButtonItems = buttonItens
    }
}
