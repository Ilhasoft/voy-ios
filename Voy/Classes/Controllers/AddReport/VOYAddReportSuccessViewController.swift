//
//  VOYAddReportSuccessViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class VOYAddReportSuccessViewController: UIViewController {

    @IBOutlet var infoView:VOYInfoView!
    @IBOutlet var btNewReport:UIButton!
    @IBOutlet var btClose:UIButton!
    
    init() {
        super.init(nibName: "VOYAddReportSuccessViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
    }
    
    @IBAction func btNewReportTapped() {
        let navigationController = UINavigationController(rootViewController: VOYThemeListViewController())
        let slideMenuController = SlideMenuController(mainViewController: navigationController, rightMenuViewController: VOYNotificationViewController())
        
        UIViewController.switchRootViewController(slideMenuController, animated: true) { }
    }
    
    @IBAction func btCloseTapped() {
        if let sharedInstance = VOYReportListViewController.sharedInstance {
            self.navigationController?.popToViewController(sharedInstance, animated: true)
        }
//        let navigationController = UINavigationController(rootViewController: self.navigationController!.viewControllers[1])
//        let slideMenuController = SlideMenuController(mainViewController: navigationController, rightMenuViewController: VOYNotificationViewController())
//
//        UIViewController.switchRootViewController(slideMenuController, animated: true) { }
    }

}
