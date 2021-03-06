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

class VOYReportDetailViewController: UIViewController {

    @IBOutlet weak var scrollViewMedias: ISScrollViewPage!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var viewTags: TagListView!
    @IBOutlet weak var btComment: UIButton!
    
    var mediaList = [UIImage]()
    
    init() {
        super.init(nibName: "VOYReportDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setupScrollViewMedias()
        setupNavigationItem()
        setupViewTags()
    }
    
    func setupViewTags() {
        self.viewTags.addTags(["Accessibility","Security","Community"])
    }
    
    func setupNavigationItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        let barButtonItemOptions = UIBarButtonItem(image: #imageLiteral(resourceName: "combinedShape").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showActionSheet))
        let barButtonItemIssue = UIBarButtonItem(image: #imageLiteral(resourceName: "issue").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showIssue))
        let imageView = UIImageView(frame: CGRect(x: -13, y: 5, width: 32, height: 31))
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 31))
        imageView.image = #imageLiteral(resourceName: "avatar14")
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 32)
        imageView.heightAnchor.constraint(equalToConstant: 31)
        v.addSubview(imageView)
        self.navigationItem.titleView = v
        self.navigationItem.rightBarButtonItems = [barButtonItemOptions,barButtonItemIssue]
    }
    
    @objc func showIssue() {
        let alertInfoController = VOYAlertViewController(title: "Issues reported in your report", message: "Try to send more photos of this problem and talk more about it.", buttonNames: ["Edit Report","Close"])
        alertInfoController.delegate = self
        alertInfoController.show(true, inViewController: self)
    }
    
    func setupScrollViewMedias() {
        mediaList = [#imageLiteral(resourceName: "panda"),#imageLiteral(resourceName: "panda"),#imageLiteral(resourceName: "panda")]
        pageControl.numberOfPages = mediaList.count
        scrollViewMedias.scrollViewPageType = .horizontally
        scrollViewMedias.scrollViewPageDelegate = self
        scrollViewMedias.setPaging(true)
        for i in 0...mediaList.count-1 {
            let mediaPlayView = VOYPlayMediaView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 161))
            mediaPlayView.imgView.image = mediaList[i]
            scrollViewMedias.addCustomView(mediaPlayView)
        }
        
    }
    
    @objc private func showActionSheet() {
        let actionSheetViewController = VOYActionSheetViewController(buttonNames: ["Edit Report"], icons: nil)
        actionSheetViewController.delegate = self
        actionSheetViewController.show(true, inViewController: self)
    }
    
    @IBAction func btCommentTapped(_ sender: Any) {
        self.navigationController?.pushViewController(VOYCommentViewController(), animated: true)
    }
}
extension VOYReportDetailViewController : ISScrollViewPageDelegate {
    func scrollViewPageDidChanged(_ scrollViewPage: ISScrollViewPage, index: Int) {
        self.pageControl.currentPage = index
    }
}

extension VOYReportDetailViewController : VOYActionSheetViewControllerDelegate {
    func cancelButtonDidTap(actionSheetViewController: VOYActionSheetViewController) {
        actionSheetViewController.close()
    }
    
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        actionSheetViewController.close()
        self.navigationController?.pushViewController(VOYAddReportAttachViewController(), animated: true)
    }
}

extension VOYReportDetailViewController : VOYAlertViewControllerDelegate {
    func buttonDidTap(alertController: VOYAlertViewController, button: UIButton, index: Int) {
        alertController.close()
        switch index {
        case 0:
            self.navigationController?.pushViewController(VOYAddReportAttachViewController(), animated: true)
        case 1:
            break
        default:
            break
        }
    }
}
