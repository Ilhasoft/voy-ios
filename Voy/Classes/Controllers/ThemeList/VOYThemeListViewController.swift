//
//  VOYThemeListViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYThemeListViewController: UIViewController {

    @IBOutlet weak var lbThemesCount: UILabel!
    @IBOutlet weak var tbView: ISOnDemandTableView!
    
    init() {
        super.init(nibName: "VOYThemeListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
}
