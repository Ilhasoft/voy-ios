//
//  LoginViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView

class VOYLoginViewController: UIViewController, NVActivityIndicatorViewable {

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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: Class Methods
    
    
    //MARK: Component Events
    
    @IBAction func btLoginTapped(_ sender: Any) {
        let alertController = VOYAlertViewController(title: "Error", message: "Maybe you entered a wrong username or password!", buttonNames:["Ok"])
        
        
        let navigationController = UINavigationController(rootViewController: VOYThemeListViewController())
        let slideMenuController = SlideMenuController(mainViewController: navigationController, rightMenuViewController: VOYNotificationViewController())
        
        startAnimating()
        VOYLoginInteractor.login(username: self.userNameView.txtField.text!, password: self.passwordView.txtField.text!) { (user , error) in
            self.stopAnimating()
            if let _ = error {
                alertController.show(true, inViewController: self)
            }else if user != nil {
                self.navigationController?.pushViewController(slideMenuController, animated: true)
            }else {
                alertController.show(true, inViewController: self)
            }
        }
        
    }
    
}
