//
//  VOYGrowingTextView.swift
//  Voy
//
//  Created by Daniel Amaral on 20/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import GrowingTextView
import DataBindSwift

public class DataBindGrowingTextView: GrowingTextView, DataBindable {
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var required: Bool = false
    public var requiredError: String = ""
    public var fieldType: String = "Text"
    public var fieldTypeError: String = ""
    public var fieldPath: String = ""
    public var persist: Bool = true
}
