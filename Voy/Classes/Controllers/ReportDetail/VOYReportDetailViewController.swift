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

class VOYReportDetailViewController: UIViewController {

    @IBOutlet weak var scrollViewMedias: DataBindScrollViewPageSwift!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lbTitle: DataBindLabel!
    @IBOutlet weak var lbDate: DataBindLabel!
    @IBOutlet weak var lbDescription: DataBindLabel!
    @IBOutlet weak var viewTags: TagListView!
    @IBOutlet weak var btComment: UIButton!
    @IBOutlet weak var dataBindView: DataBindView!
    
    var report:VOYReport!
    
    init(report:VOYReport) {
        self.report = report
        super.init(nibName: "VOYReportDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollViewMedias.scrollViewPageType = .horizontally
        scrollViewMedias.scrollViewPageDelegate = self
        scrollViewMedias.setPaging(true)
        
        dataBindView.delegate = self
        dataBindView.fillFields(withObject:report.toJSON())
        setupNavigationItem()
        setupViewTags()
        
    }
    
    func setupViewTags() {
        if let tags = self.report.tags {
            self.viewTags.addTags(tags)
        }
    }
    
    func setupNavigationItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        let barButtonItemOptions = UIBarButtonItem(image: #imageLiteral(resourceName: "combinedShape").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showActionSheet))
        let barButtonItemIssue = UIBarButtonItem(image: #imageLiteral(resourceName: "issue").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showIssue))
        let imageView = UIImageView(frame: CGRect(x: -13, y: 5, width: 32, height: 31))
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 31))
        imageView.image = #imageLiteral(resourceName: "avatar14")
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 31).isActive = true
        v.addSubview(imageView)
        self.navigationItem.titleView = v
        self.navigationItem.rightBarButtonItems = [barButtonItemOptions,barButtonItemIssue]
    }
    
    @objc func showIssue() {
        let alertInfoController = VOYAlertViewController(title: "Issues reported in your report", message: "Try to send more photos of this problem and talk more about it.", buttonNames: ["Edit Report","Close"])
        alertInfoController.delegate = self
        alertInfoController.show(true, inViewController: self)
    }
    
    func setupScrollViewMedias(media:VOYMedia) {
        let mediaPlayView = VOYPlayMediaView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 161))
        mediaPlayView.setup(media: media)
        mediaPlayView.delegate = self
        scrollViewMedias.addCustomView(mediaPlayView)
        
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

extension VOYReportDetailViewController : DataBindViewDelegate {
    func didFetch(error: Error?) {
        
    }
    
    func willFill(component: Any, value: Any) -> Any? {
        if let component = component as? UILabel {
            if component == self.lbDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                let dateString = value as! String
                let date = dateFormatter.date(from: dateString)
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "MMM"
                dateFormatter2.dateStyle = .medium
                
                lbDate.text = dateFormatter2.string(from: date!)
                
                return nil
            }
            
        }else if let _ = component as? UIScrollView {
            if let values = value as? [[String:Any]] {
                for mediaObject in values {
                    let media = VOYMedia(JSON: mediaObject)!
                    setupScrollViewMedias(media: media)
                }
                self.pageControl.numberOfPages = scrollViewMedias.views!.count
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

extension VOYReportDetailViewController : VOYPlayMediaViewDelegate {
    func mediaDidTap(mediaView: VOYPlayMediaView) {
        let dataSource = PhotosDataSource(photos:[Photo(image:mediaView.imgView.image)])
        let photosViewController = PhotosViewController(dataSource: dataSource)
        self.present(photosViewController, animated: true) {
            
        }
    }
}
