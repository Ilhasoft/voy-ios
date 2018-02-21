//
//  VOYAddReportTagsViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import TagListView

class VOYAddReportTagsViewController: UIViewController {

    @IBOutlet var lbTitle:UILabel!
    @IBOutlet var viewTags:TagListView!
    
    var selectedTags = [String]()
    
    var report:VOYReport!
    
    init(report:VOYReport) {
        self.report = report
        super.init(nibName: "VOYAddReportTagsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        loadTags()
        addNextButton()
    }

    func addNextButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(save))
    }
    
    @objc func save() {
        self.report.tags = selectedTags
        self.report.theme = VOYTheme.activeTheme()!.id
        let location = "POINT(\(VOYLocationManager.longitude) \(VOYLocationManager.latitude))"
        self.report.location = location
        
        VOYAddReportInteractor.save(report: report) { (error,reporID) in
            self.navigationController?.pushViewController(VOYAddReportSuccessViewController(), animated: true)
        }
        
    }
    
    private func loadTags() {
        viewTags.addTags(VOYTheme.activeTheme()!.tags)
        viewTags.delegate = self
    }
    
    private func addTag(tagView:TagView, title:String) {
        let index = selectedTags.index {($0 == title)}
        if index != nil {
            tagView.textColor = UIColor.black
            tagView.tagBackgroundColor = VOYConstant.Color.gray
            selectedTags.remove(at: index!)
        }else {
            tagView.textColor = UIColor.white
            tagView.tagBackgroundColor = VOYConstant.Color.blue
            selectedTags.append(title)
        }
    }
    
}

extension VOYAddReportTagsViewController : TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.addTag(tagView: tagView, title: title)
    }
}
