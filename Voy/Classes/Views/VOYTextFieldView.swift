//
//  VOYTextFieldView.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DataBindSwift

protocol VOYTextFieldViewDelegate: class {
    func textFieldDidEndEditing(_ textFieldView: VOYTextFieldView)
    func textFieldDidChange(_ textFieldView: VOYTextFieldView, text: String)
}

@IBDesignable
class VOYTextFieldView: UIView {

    static let activeColor  = UIColor.voyBlue
    static let defaultColor = UIColor.voyGray

    weak var delegate: VOYTextFieldViewDelegate?

    @IBInspectable var path: String! {
        didSet {
            self.txtField.fieldPath = path
        }
    }
    @IBInspectable var placeholder: String = "" {
        didSet {
            self.txtField.placeholder = placeholder
            self.lbFieldName.text = placeholder
        }
    }
    @IBInspectable var password: Bool = false {
        didSet {
            self.txtField.isSecureTextEntry = password
        }
    }

    @IBInspectable var showBottomView: Bool = true {
        didSet {
            self.viewBottom.isHidden = !showBottomView
        }
    }

    @IBInspectable var editEnabled: Bool = true {
        didSet {
            self.txtField.isEnabled = editEnabled
        }
    }

    @IBOutlet var heightViewBottom: NSLayoutConstraint!
    @IBOutlet var txtField: DataBindTextField!
    @IBOutlet var lbFieldName: UILabel!
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var contentView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

extension VOYTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.heightViewBottom.constant = 2
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        self.viewBottom.backgroundColor = VOYTextFieldView.activeColor
        self.txtField.textColor = VOYTextFieldView.activeColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing(self)
        self.heightViewBottom.constant = 1
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        self.viewBottom.backgroundColor = VOYTextFieldView.defaultColor
        self.txtField.textColor = UIColor.black
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        let newText = (textField.safeText as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count

        self.delegate?.textFieldDidChange(self, text: newText)

        if numberOfChars > 0 && self.lbFieldName.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.lbFieldName.alpha = 1
            })
        } else if numberOfChars == 0 && self.lbFieldName.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.lbFieldName.alpha = 0
            })
        }
        return true
    }
}
