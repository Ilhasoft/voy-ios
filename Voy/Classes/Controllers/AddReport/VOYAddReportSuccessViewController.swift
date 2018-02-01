//
//  VOYAddReportSuccessViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
    }
    
    @IBAction func btNewReportTapped() {
    
    }
    
    @IBAction func btCloseTapped() {
        
    }

}
