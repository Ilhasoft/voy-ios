//
//  VOYScrollView.swift
//  Voy
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISScrollViewPageSwift
import RestBind

class VOYScrollView: ISScrollViewPage, RestBindable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var required: Bool = false
    public var requiredError: String = ""
    public var fieldType: String = "None"
    public var fieldTypeError: String = ""
    @IBInspectable open var fieldPath: String = ""
    public var persist: Bool = false
    

}
