//
//  VOYAddReportTagsViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import TagListView
import NVActivityIndicatorView

class VOYAddReportTagsViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var viewTags: TagListView!

    var presenter: VOYAddReportTagsPresenter!

    var selectedTags = [String]() {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = !selectedTags.isEmpty
        }
    }

    init(report: VOYReport) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        presenter = VOYAddReportTagsPresenter(
            report: report,
            dataSource: VOYAddReportRepository(reachability: VOYDefaultReachability()),
            view: self
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        addNextButton()
        presenter.onViewDidLoad()
    }

    private func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: localizedString(.send),
            style: .plain,
            target: self,
            action: #selector(onSaveButtonTapped)
        )
    }

    @objc func onSaveButtonTapped() {
        presenter.saveReport(selectedTags: selectedTags)
    }

    fileprivate func addTag(tagView: TagView, title: String) {
        let index = selectedTags.index { ($0 == title) }
        if index != nil {
            tagView.textColor = UIColor.black
            tagView.tagBackgroundColor = UIColor.voyGray
            selectedTags.remove(at: index!)
        } else {
            tagView.textColor = UIColor.white
            tagView.tagBackgroundColor = UIColor.voyBlue
            selectedTags.append(title)
        }
    }

    // MARK: - Localization

    private func setupLocalization() {
        lbTitle.text = localizedString(.addTags)
    }

}

extension VOYAddReportTagsViewController: VOYAddReportTagsContract {
    func showProgress() {
        self.startAnimating()
    }

    func dismissProgress() {
        self.stopAnimating()
    }

    func loadTags() {
        viewTags.addTags(VOYTheme.activeTheme()!.tags)
        viewTags.delegate = self
    }

    func selectTags(tags: [String]) {
        self.selectedTags = tags
        for tag in tags {
            for viewTag in viewTags.tagViews where viewTag.titleLabel!.text! == tag {
                viewTag.textColor = UIColor.white
                viewTag.tagBackgroundColor = UIColor.voyBlue
            }
        }
    }

    func navigateToSuccessScreen() {
        self.navigationController?.pushViewController(VOYAddReportSuccessViewController(), animated: true)
    }
}

extension VOYAddReportTagsViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.addTag(tagView: tagView, title: title)
    }
}
