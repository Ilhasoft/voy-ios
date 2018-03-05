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

enum RedirectUserFor {
    case error
    case success
}

class VOYLoginViewController: UIViewController, NVActivityIndicatorViewable, VOYLoginContract {

    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet weak var stackViewIcons: UIStackView!
    @IBOutlet weak var lbHey: UILabel!
    @IBOutlet weak var userNameView: VOYTextFieldView!
    @IBOutlet weak var passwordView: VOYTextFieldView!
    @IBOutlet weak var btLogin: UIView!
    
    var presenter: VOYLoginPresenter?
    
    init() {
        super.init(nibName:"VOYLoginViewController",bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = VOYLoginPresenter(dataSource: VOYLoginRepository(), view: self)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //MARK: VOYLoginContract
    
    func redirectController(loginAuth: RedirectUserFor) {
        let alertController = VOYAlertViewController(title: "Error", message: "Maybe you entered a wrong username or password!", buttonNames:["Ok"])
        let navigationController = UINavigationController(rootViewController: VOYThemeListViewController(userJustLogged: true))
        let slideMenuController = SlideMenuController(mainViewController: navigationController, rightMenuViewController: VOYNotificationViewController())
        self.stopAnimating()
        switch loginAuth {
        case .success:
            guard let navigationController = self.navigationController else { return }
            navigationController.pushViewController(slideMenuController, animated: true)
        case .error:
            alertController.show(true, inViewController: self)
        }
    }
    
    //MARK: Component Events
    
    @IBAction func btLoginTapped(_ sender: Any) {
        self.view.endEditing(true)
        startAnimating()
        guard let presenter = presenter else { return }
        presenter.login(username: self.userNameView.txtField.text!, password: self.passwordView.txtField.text!)
    }
    
}
