//
//  VOYReportListViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 02/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import RestBind
import ISOnDemandTableView
import NVActivityIndicatorView

class VOYReportListViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var viewInfo:VOYInfoView!
    @IBOutlet var btAddReport:UIButton!
    @IBOutlet var tableViewApproved:RestBindTableView!
    @IBOutlet var tableViewPending:RestBindTableView!
    @IBOutlet var tableViewNotApproved:RestBindTableView!
    @IBOutlet var segmentedControl:UISegmentedControl!
    
    static var sharedInstance:VOYReportListViewController?
    var theme:VOYTheme!
    var allDataFinishedLoad = false
    var dataLoadTime = 0
    
    init() {
        super.init(nibName: "VOYReportListViewController", bundle: nil)
        VOYReportListViewController.sharedInstance = self
        self.theme = VOYTheme.activeTheme()!
        self.title = theme.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"), style: .plain, target: self, action: #selector(openNotifications))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
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
        startAnimating()
        tableViewApproved.separatorColor = UIColor.clear
        tableViewApproved.register(UINib(nibName: "VOYReportTableViewCell", bundle: nil), forCellReuseIdentifier: "VOYReportTableViewCell")
        tableViewApproved.onDemandTableViewDelegate = self
        tableViewApproved.interactor = RestBindTableViewProvider(configuration:tableViewApproved.getConfiguration(),
                                                                 params: ["theme":self.theme.id,"status":1])
        tableViewApproved.loadContent()
        
        tableViewPending.separatorColor = UIColor.clear
        tableViewPending.register(UINib(nibName: "VOYReportTableViewCell", bundle: nil), forCellReuseIdentifier: "VOYReportTableViewCell")
        tableViewPending.onDemandTableViewDelegate = self
        tableViewPending.interactor = RestBindTableViewProvider(configuration:tableViewPending.getConfiguration(),
                                                                params: ["theme":self.theme.id,"status":2])
        tableViewPending.loadContent()
        
        tableViewNotApproved.separatorColor = UIColor.clear
        tableViewNotApproved.register(UINib(nibName: "VOYReportTableViewCell", bundle: nil), forCellReuseIdentifier: "VOYReportTableViewCell")
        tableViewNotApproved.onDemandTableViewDelegate = self
        tableViewNotApproved.interactor = RestBindTableViewProvider(configuration:tableViewNotApproved.getConfiguration(),
                                                                    params: ["theme":self.theme.id,"status":3])
        tableViewNotApproved.loadContent()
        
        self.segmentedControl.selectedSegmentIndex = 0
        segmentedControlTapped()
    }
    
    func showInfoViewIfNecessary(tableView:RestBindTableView) {
        if tableView.interactor?.objects.count == 0 && allDataFinishedLoad {
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.viewInfo.setupWith(titleAndColor: ["Hello!":VOYConstant.Color.blue],
                                        messageAndColor: ["You have not created any report yet":UIColor.black])
            case 1:
                self.viewInfo.setupWith(titleAndColor: ["Great!":VOYConstant.Color.blue],
                                        messageAndColor: ["All you reports has been approved":UIColor.black])
            case 2:
                self.viewInfo.setupWith(titleAndColor: ["Great Job!":UIColor(hex: "7ed321")],
                                        messageAndColor: ["All you reports has been approved":UIColor.black])
            default:
                break
            }
            self.viewInfo.isHidden = false
        }else {
            self.viewInfo.isHidden = true
        }
    }
    
    @IBAction func btAddReportTapped(_ sender: Any) {
        self.navigationController?.pushViewController(VOYAddReportAttachViewController(), animated: true)
    }
    
    @IBAction func segmentedControlTapped() {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            tableViewApproved.isHidden = false
            tableViewPending.isHidden = true
            tableViewNotApproved.isHidden = true
            showInfoViewIfNecessary(tableView: tableViewApproved)
            break
        case 1:
            tableViewApproved.isHidden = true
            tableViewPending.isHidden = false
            tableViewNotApproved.isHidden = true
            showInfoViewIfNecessary(tableView: tableViewPending)
            break
        case 2:
            tableViewApproved.isHidden = true
            tableViewPending.isHidden = true
            tableViewNotApproved.isHidden = false
            showInfoViewIfNecessary(tableView: tableViewNotApproved)
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
        dataLoadTime+=1
        allDataFinishedLoad = dataLoadTime >= 3
        showInfoViewIfNecessary(tableView: tableView as! RestBindTableView)
        self.stopAnimating()
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! VOYReportTableViewCell
        self.navigationController?.pushViewController(VOYReportDetailViewController(report:VOYReport(JSON:cell.object.JSON)!), animated: true)
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
