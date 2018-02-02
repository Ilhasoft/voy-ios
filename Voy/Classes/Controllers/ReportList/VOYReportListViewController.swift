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

    @IBOutlet var btAddReport:UIButton!
    @IBOutlet var tbView:ISOnDemandTableView!
    @IBOutlet var segmentedControl:UISegmentedControl!
    
    init() {
        super.init(nibName: "VOYReportListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        tbView.separatorColor = UIColor.clear
        tbView.register(UINib(nibName: "VOYReportTableViewCell", bundle: nil), forCellReuseIdentifier: "VOYReportTableViewCell")
        tbView.onDemandTableViewDelegate = self
        tbView.interactor = VOYReportListTableViewProvider()
        tbView.loadContent()
        
        
    }
    
    @IBAction func btAddReportTapped(_ sender: Any) {
        self.navigationController?.pushViewController(VOYAddReportAttachViewController(), animated: true)
    }
    
    @IBAction func segmentedControlTapped() {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        case 2:
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
        
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, onContentLoad lastData: [Any]?, withError error: Error?) {
        
    }
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
}

