//
//  VOYThemeListViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView
import DropDown

class VOYThemeListViewController: UIViewController {

    @IBOutlet weak var lbThemesCount: UILabel!
    @IBOutlet weak var tbView: ISOnDemandTableView!
    
    var selectedReportView:VOYSelectedReportView!
    var dropDown = DropDown()
    
    init() {
        super.init(nibName: "VOYThemeListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        setupTableView()
        setupButtonItems()
        setupDropDown()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupButtonItems() {
        let image = #imageLiteral(resourceName: "group14Copy2").withRenderingMode(.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openAccount))
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"), style: .plain, target: self, action: #selector(openNotifications))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupReportsTouch() {
        
        
    }
    
    func setupDropDown() {
        
        selectedReportView = VOYSelectedReportView(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
        selectedReportView.widthAnchor.constraint(equalToConstant: 180)
        selectedReportView.heightAnchor.constraint(equalToConstant: 40)
        selectedReportView.delegate = self
        self.navigationItem.titleView = selectedReportView            
        
        dropDown.anchorView = selectedReportView
        dropDown.bottomOffset = CGPoint(x: 0, y: selectedReportView.bounds.size.height)
        dropDown.dataSource = ["Project 01","Project 02","Project 03"]
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.textLabel!.textAlignment = .center
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedReportView.lbTitle.text = item
        }
    }
    
    @objc func openAccount() {
        self.navigationController?.pushViewController(VOYAccountViewController(), animated: true)
    }
    
    @objc func openNotifications() {
        self.slideMenuController()?.openRight()
    }
    
    func setupTableView() {        
        tbView.separatorColor = UIColor.clear
        tbView.register(UINib(nibName: "VOYThemeTableViewCell", bundle: nil), forCellReuseIdentifier: "VOYThemeTableViewCell")
        tbView.onDemandTableViewDelegate = self
        tbView.interactor = VOYThemeListTableViewProvider()
        tbView.loadContent()
    }

}

extension VOYThemeListViewController : ISOnDemandTableViewDelegate {
    func onDemandTableView(_ tableView: ISOnDemandTableView, reuseIdentifierForCellAt indexPath: IndexPath) -> String {
        return "VOYThemeTableViewCell"
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, setupCell cell: UITableViewCell, at indexPath: IndexPath) {
        
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, onContentLoad lastData: [Any]?, withError error: Error?) {
        
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(VOYReportListViewController(selectedReport:selectedReportView.lbTitle.text!), animated: true)
    }
}

extension VOYThemeListViewController : VOYSelectedReportViewDelegate {
    func seletecReportDidTap() {
        dropDown.show()
    }
}
