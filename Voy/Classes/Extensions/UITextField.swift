//
//  VOYTextFieldExtension.swift
//  Voy
//
//  Created by Dielson Sales on 20/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension UITextField {
    var safeText: String {
        return self.text ?? ""
    }
}
