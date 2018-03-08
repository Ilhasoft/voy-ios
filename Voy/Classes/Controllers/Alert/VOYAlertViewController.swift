//
//  VOYAlertViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYAlertViewControllerDelegate: class {
    func buttonDidTap(alertController: VOYAlertViewController, button: UIButton, index: Int)
}

class VOYAlertViewController: ISModalViewController {

    @IBOutlet private var lbTitle: UILabel!
    @IBOutlet private var lbMessage: UILabel!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet weak var heightStackView: NSLayoutConstraint!
    
    private var buttonHeight = 49
    private var buttonNames = [String]()
    
    private var messageTitle = "title"
    private var message = "message"
    
    weak var delegate: VOYAlertViewControllerDelegate?
    
    init(title: String, message: String, buttonNames: [String]? = ["Ok"]) {
        self.messageTitle = title
        self.message = message
        self.buttonNames = buttonNames!
        super.init(nibName: "VOYAlertViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "VOYAlertViewController", bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
        setupLayout()
    }
    
    private func setupLayout() {

        self.lbTitle.text = messageTitle
        self.lbMessage.text = message
        
        self.heightStackView.constant = CGFloat(buttonHeight * buttonNames.count)
        self.view.layoutIfNeeded()
        
        for (index, buttonName) in buttonNames.enumerated() {
            let button = UIButton()
            button.titleLabel!.font = UIFont.systemFont(ofSize: 16)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.voyGray.cgColor
            button.setTitleColor(UIColor.voyLightBlue, for: .normal)
            button.setTitle(buttonName, for: .normal)
            button.backgroundColor = UIColor.white
            button.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
            button.addGestureRecognizer(tapGesture)
            self.stackView.addArrangedSubview(button)
        }
    }

    @objc private func buttonTapped(gesture: UIGestureRecognizer) {
        guard let button = gesture.view as? UIButton else { return }
        if let delegate = self.delegate {
            delegate.buttonDidTap(alertController: self, button: button, index: button.tag)
        } else {
            self.close()
        }
    }
    
}
