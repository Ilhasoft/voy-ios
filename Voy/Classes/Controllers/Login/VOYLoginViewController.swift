//
//  LoginViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYLoginViewController: UIViewController {

    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet weak var stackViewIcons: UIStackView!
    @IBOutlet weak var lbHey: UILabel!
    @IBOutlet weak var userNameView: VOYTextFieldView!
    @IBOutlet weak var passwordView: VOYTextFieldView!
    @IBOutlet weak var btLogin: UIView!
    
    init() {
        super.init(nibName:"VOYLoginViewController",bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: Class Methods
    
    
    //MARK: Component Events
    
    @IBAction func btLoginTapped(_ sender: Any) {
        let alertController = VOYAlertViewController(title: "Internet connection", message: "We couldn’t identify an active internet connection, please check your connection and try again.", buttonNames:["Ok","ok"])
        alertController.delegate = self
        alertController.show(true, inViewController: self)
    }
    
}

extension VOYLoginViewController : VOYAlertViewControllerDelegate {
    func buttonDidTap(alertController: VOYAlertViewController, button: UIButton, index: Int) {
        alertController.close()
    }
}
