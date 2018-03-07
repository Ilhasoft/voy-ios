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

class VOYAddReportTagsViewController: UIViewController, NVActivityIndicatorViewable, VOYAddReportTagsContract {
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var viewTags: TagListView!
    
    var presenter: VOYAddReportTagsPresenter?
    
    var selectedTags = [String]() {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = !selectedTags.isEmpty
        }
    }
    
    var report: VOYReport!
    
    init(report: VOYReport) {
        self.report = report
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = VOYAddReportTagsPresenter(dataSource: VOYAddReportRepository(reachability: VOYReachabilityImpl()), view: self)
        edgesForExtendedLayout = []
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        addNextButton()
        loadTags()
        selectTags()
    }

    func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: localizedString(.send), style: .plain, target: self, action: #selector(save))
    }
    
    @objc func save() {
        guard let presenter = self.presenter else { return }
        self.report.tags = selectedTags
        self.report.theme = VOYTheme.activeTheme()!.id
        let location = "POINT(\(VOYLocationManager.longitude) \(VOYLocationManager.latitude))"
        self.report.location = location
        presenter.saveReport(report: report)
    }
    
    func stopLoadingAnimation() {
        self.stopAnimating()
    }
    
    func startLoadingAnimation() {
        self.startAnimating()
    }
    
    func showSuccess() {
        self.navigationController?.pushViewController(VOYAddReportSuccessViewController(), animated: true)
    }
    
    internal func loadTags() {
        viewTags.addTags(VOYTheme.activeTheme()!.tags)
        viewTags.delegate = self
    }
    
    internal func selectTags() {
        guard let tags = self.report.tags else {
            return
        }
        self.selectedTags = tags
        
        for tag in tags {
            
            let tagViewFiltered = self.viewTags.tagViews.filter { ($0.titleLabel!.text! == tag) }
            
            guard !tagViewFiltered.isEmpty else { return }
            
            tagViewFiltered.first!.textColor = UIColor.white
            tagViewFiltered.first!.tagBackgroundColor = UIColor.voyBlue
            
        }
    }
    
    internal func addTag(tagView: TagView, title: String) {
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

extension VOYAddReportTagsViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.addTag(tagView: tagView, title: title)
    }
}
