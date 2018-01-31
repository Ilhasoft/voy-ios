//
//  VOYTextFieldView.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

@IBDesignable
class VOYTextFieldView: UIView {
    
    static let activeColor  = UIColor(hex: "00cbff")
    static let defaultColor = UIColor(hex:"f0f0f0")
    
    @IBInspectable var placeholder:String = "" {
        didSet {
            self.txtField.placeholder = placeholder
            self.lbFieldName.text = placeholder
        }
    }
    @IBInspectable var password:Bool = false {
        didSet {
            self.txtField.isSecureTextEntry = password
        }
    }
    
    @IBOutlet var heightViewBottom:NSLayoutConstraint!
    @IBOutlet var txtField:UITextField!
    @IBOutlet var lbFieldName:UILabel!
    @IBOutlet var viewBottom:UIView!
    @IBOutlet var contentView:UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "VOYTextFieldView", bundle: Bundle(for: VOYTextFieldView.self))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        self.txtField.delegate = self
    }

}

extension VOYTextFieldView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.heightViewBottom.constant = 2
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        self.viewBottom.backgroundColor = VOYTextFieldView.activeColor
        self.txtField.textColor = VOYTextFieldView.activeColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.heightViewBottom.constant = 1
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        self.viewBottom.backgroundColor = VOYTextFieldView.defaultColor
        self.txtField.textColor = UIColor.black
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        
        if numberOfChars > 0 && self.lbFieldName.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.lbFieldName.alpha = 1
            })
        }else if numberOfChars == 0 && self.lbFieldName.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.lbFieldName.alpha = 0
            })
        }
        
        return true
    }
    
}

