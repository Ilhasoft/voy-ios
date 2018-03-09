//
//  VOYNotificationViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

class VOYNotificationViewController: UIViewController, VOYNotificationContract {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: ISOnDemandTableView!
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        lbTitle.text = localizedString(.notifications)
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VOYNotificationRepository(reachability: VOYReachabilityImpl()).getNotifications()
    }

}

extension VOYNotificationViewController: ISOnDemandTableViewDelegate {
//    func onDemandTableView(_ tableView: ISOnDemandTableView, didSelectRowAt indexPath: IndexPath) {
//        self.view.endEditing(true)
//    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, reuseIdentifierForCellAt indexPath: IndexPath) -> String {
        return NSStringFromClass(VOYNotificationTableViewCell.self)
    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, setupCell cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? VOYNotificationTableViewCell {
            cell.setupCell(with: "Cell message example")
        }
    }
    
    func onDemandTableView(_ tableView: ISOnDemandTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//extension VOYNotificationViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 9
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    }
//
//
//}

