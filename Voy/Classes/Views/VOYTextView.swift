//
//  VOYTextView.swift
//  Voy
//
//  Created by Daniel Amaral on 06/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import GrowingTextView

protocol VOYTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

@IBDesignable
class VOYTextView: UIView {
    
    static let activeColor  = VOYConstant.Color.blue
    static let defaultColor = VOYConstant.Color.gray
    
    var delegate:VOYTextViewDelegate?
    
    @IBInspectable var path:String = "" {
        didSet {
            self.txtView.fieldPath = path
        }
    }
    @IBInspectable var placeholder:String = "" {
        didSet {
            self.txtView.placeholder = placeholder
            self.lbFieldName.text = placeholder
        }
    }

    @IBInspectable var showBottomView:Bool = true {
        didSet {
            self.viewBottom.isHidden = !showBottomView
        }
    }
    
    @IBInspectable var editEnabled:Bool = true {
        didSet {
            self.txtView.isEditable = editEnabled
        }
    }
    
    @IBOutlet var heightViewBottom:NSLayoutConstraint!
    @IBOutlet var txtView:DataBindGrowingTextView!
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
        let nib = UINib(nibName: "VOYTextView", bundle: Bundle(for: VOYTextView.self))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        self.txtView.delegate = self
    }
    
}

extension VOYTextView : GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        self.delegate?.textViewDidChangeHeight(textView, height: height)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.heightViewBottom.constant = 2
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        self.viewBottom.backgroundColor = VOYTextFieldView.activeColor
        textView.textColor = VOYTextFieldView.activeColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.heightViewBottom.constant = 1
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        self.viewBottom.backgroundColor = VOYTextFieldView.defaultColor
        textView.textColor = UIColor.black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
        let newText = (textView.text! as NSString).replacingCharacters(in: range, with: text)
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


