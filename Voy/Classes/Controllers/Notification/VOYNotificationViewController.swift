//
//  VOYNotificationViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 01/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYNotificationViewController: UIViewController, VOYNotificationContract {
    
    @IBOutlet var lbTitle: UILabel!

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
    }
    
    private func setupLocalization() {
        lbTitle.text = localizedString(.notifications)
    }

}
