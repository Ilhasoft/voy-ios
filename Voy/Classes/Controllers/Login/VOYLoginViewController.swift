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

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var stackViewIcons: UIStackView!
    @IBOutlet weak var lbHey: UILabel!
    @IBOutlet weak var userNameView: VOYTextFieldView!
    @IBOutlet weak var passwordView: VOYTextFieldView!
    @IBOutlet weak var btLogin: UIButton!

    var presenter: VOYLoginPresenter!

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        self.presenter = VOYLoginPresenter(dataSource: VOYLoginRepository(), view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupLocalization()
    }

    // MARK: - Component Events

    @IBAction func btLoginTapped(_ sender: Any) {
        self.view.endEditing(true)
        presenter.login(username: self.userNameView.txtField.safeText, password: self.passwordView.txtField.safeText)
    }

    // MARK: - Localization

    private func setupLocalization() {
        lbHey.text = localizedString(.hey)
        userNameView.placeholder = localizedString(.username)
        passwordView.placeholder = localizedString(.password)
        btLogin.setTitle(localizedString(.login), for: .normal)
    }
}

extension VOYLoginViewController: VOYLoginContract {
    func startProgressIndicator() {
        startAnimating()
    }

    func stopProgressIndicator() {
        stopAnimating()
    }

    func redirectController() {
        let navigationController = UINavigationController(
                rootViewController: VOYThemesViewController()
        )
        let slideMenuController = SlideMenuController(
                mainViewController: navigationController,
                rightMenuViewController: VOYNotificationViewController()
        )
        self.navigationController?.pushViewController(slideMenuController, animated: true)
    }

    func presentErrorAlert() {
        let alertController = VOYAlertViewController(
                title: localizedString(.error),
                message: localizedString(.loginErrorMessage),
                buttonNames: [localizedString(.ok)]
        )
        self.stopAnimating()
        alertController.show(true, inViewController: self)
    }
}
