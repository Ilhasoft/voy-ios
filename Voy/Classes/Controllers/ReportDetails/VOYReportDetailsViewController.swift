//
//  VOYReportDetailsViewController.swift
//  Voy
//
//  Created by Dielson Sales on 27/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import TagListView

class VOYReportDetailsViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var viewTags: TagListView!

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
        setupTagsView()
        presenter.onViewDidLoad()
    }

    // MARK: - Private methods

    private func setupTagsView() {
        viewTags.backgroundColor = UIColor.white
        viewTags.textColor = UIColor.white
        viewTags.selectedTextColor = UIColor.white
        viewTags.cornerRadius = 7
        viewTags.paddingY = 9
        viewTags.paddingX = 22
        viewTags.marginY = 13
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
}
