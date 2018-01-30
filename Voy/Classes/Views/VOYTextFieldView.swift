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
    
    static let activeColor = UIColor.blue
    static let defaultColor = UIColor.gray
    
    @IBOutlet var txtField:UITextField!
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
        self.viewBottom.backgroundColor = VOYTextFieldView.activeColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewBottom.backgroundColor = VOYTextFieldView.defaultColor
    }
}
