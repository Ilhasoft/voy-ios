//
//  VOYReportListViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYReportListViewController: UIViewController {

    @IBOutlet var viewInfo:VOYInfoView!
    @IBOutlet var btAddReport:UIButton!
    @IBOutlet var tbView:RestBindTableView!
    @IBOutlet var segmentedControl:UISegmentedControl!
    
    static var sharedInstance:VOYReportListViewController?
    var theme:VOYTheme!
    
    init(theme:VOYTheme) {
        super.init(nibName: "VOYReportListViewController", bundle: nil)
        VOYReportListViewController.sharedInstance = self
        self.theme = theme
        self.title = theme.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"), style: .plain, target: self, action: #selector(openNotifications))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func openNotifications() {
        self.slideMenuController()?.openRight()
    }
    
    func setupTableView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        tbView.separatorColor = UIColor.clear
        tbView.register(UINib(nibName: "VOYReportTableViewCell", bundle: nil), forCellReuseIdentifier: "VOYReportTableViewCell")
        tbView.onDemandTableViewDelegate = self
        
        self.segmentedControl.selectedSegmentIndex = 0
        segmentedControlTapped()                
    }
    
    @IBAction func btAddReportTapped(_ sender: Any) {
        self.navigationController?.pushViewController(VOYAddReportAttachViewController(), animated: true)
    }
    
    @IBAction func segmentedControlTapped() {
        var status = 0
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            status = 1
            tbView.interactor = RestBindTableViewProvider(tableViewConfiguration:tbView.getConfiguration(),
                                                          params: ["theme":self.theme.id,"status":status],
                                                          paginationCount:5)
            tbView.loadContent()
            break
        case 1:
            status = 2
            tbView.interactor = RestBindTableViewProvider(tableViewConfiguration:tbView.getConfiguration(),
                                                          params: ["theme":self.theme.id,"status":status],
                                                          paginationCount:5)
            tbView.loadContent()
            break
        case 2:
            status = 3
            tbView.interactor = RestBindTableViewProvider(tableViewConfiguration:tbView.getConfiguration(),
                                                          params: ["theme":self.theme.id,"status":status],
                                                          paginationCount:5)
            tbView.loadContent()
            break
        default:
            break
        }
    }
    

}

extension VOYReportListViewController : ISOnDemandTableViewDelegate {
    func onDemandTableView(_ tableView: ISOnDemandTableView, reuseIdentifierForCellAt indexPath: IndexPath) -> String {
        return "VOYReportTableViewCell"
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, setupCell cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? VOYReportTableViewCell {
            cell.delegate = self
        }
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, onContentLoad lastData: [Any]?, withError error: Error?) {
        if tableView.interactor?.objects.count == 0 {
            //check segmentedControl index for showing correct info view
            //TODO: self.viewInfo.isHidden = false
        }
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(VOYReportDetailViewController(), animated: true)
    }
}

extension VOYReportListViewController : VOYReportTableViewCellDelegate {
    func btResentDidTap(cell: VOYReportTableViewCell) {
        let actionSheetViewController = VOYActionSheetViewController(buttonNames: ["Resent"], icons: nil)
        actionSheetViewController.delegate = self
        actionSheetViewController.show(true, inViewController: self)
    }
}

extension VOYReportListViewController : VOYActionSheetViewControllerDelegate {
    func cancelButtonDidTap(actionSheetViewController: VOYActionSheetViewController) {
        actionSheetViewController.close()
    }
    
    func buttonDidTap(actionSheetViewController: VOYActionSheetViewController, button: UIButton, index: Int) {
        
    }
}
