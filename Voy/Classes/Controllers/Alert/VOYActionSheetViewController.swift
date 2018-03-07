//
//  VOYActionSheetVIewController.swift
//  Voy
//
//  Created by Daniel Amaral on 31/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYActionSheetViewControllerDelegate {
    func buttonDidTap(actionSheetViewController:VOYActionSheetViewController, button:UIButton, index:Int)
    func cancelButtonDidTap(actionSheetViewController:VOYActionSheetViewController)
}

class VOYActionSheetViewController: ISModalViewController {
    
    @IBOutlet private var stackView:UIStackView!
    @IBOutlet weak var heightStackView: NSLayoutConstraint!
    
    private var buttonHeight = 56
    private var buttonNames = [String]()
    private var icons = [UIImage]()
    
    var delegate:VOYActionSheetViewControllerDelegate?
    
    init(buttonNames:[String]? = ["Ok"], icons: [UIImage]? = nil) {
        self.buttonNames = buttonNames!
        if let icons = icons {
            self.icons = icons
        }
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: String(describing: type(of: self)), bundle: nibBundleOrNil)
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
                
        self.heightStackView.constant = CGFloat(buttonHeight * (buttonNames.count + 1))
        self.view.layoutIfNeeded()
        
        for (index,buttonName) in buttonNames.enumerated() {
            let button = buildButton(index:index, name: buttonName, icon: !icons.isEmpty ? icons[index] : nil)
            addAction(inButton: button)
            self.stackView.addArrangedSubview(button)
        }
        
        let cancelButton = buildButton(index: 999, name: localizedString(.cancel))
        cancelButton.backgroundColor = UIColor.voyBlue
        addAction(inButton: cancelButton)
        self.stackView.addArrangedSubview(cancelButton)
        
    }
    
    private func addAction(inButton button:UIButton) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        button.addGestureRecognizer(tapGesture)
    }
    
    @objc private func buttonTapped(gesture:UIGestureRecognizer) {
        let button = gesture.view as! UIButton
        if button.tag != 999 {
            self.delegate?.buttonDidTap(actionSheetViewController:self, button: button, index: button.tag)
        }else {
            if let delegate = self.delegate {
                delegate.cancelButtonDidTap(actionSheetViewController:self)
            }else {
                self.close()
            }
            
        }
    }
    
    private func buildButton(index:Int, name:String, icon:UIImage? = nil) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(index == 999 ? UIColor.white : UIColor.voyLightBlue, for: .normal)
        button.setTitle(name, for: .normal)
        
        if let icon = icon {
            button.setImage(icon, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        }
        
        button.backgroundColor = UIColor.white
        button.tag = index
        return button
    }
    
}

