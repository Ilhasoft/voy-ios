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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
    func reuseIdentifierForCell(at indexPath: IndexPath) -> String {
        return "VOYThemeTableViewCell"
    }
    
    func setupCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        
    }
}
