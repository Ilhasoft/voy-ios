//
//  UILabel.swift
//  Voy
//
//  Created by Dielson Sales on 21/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension UILabel {
    var safeText: String {
        return self.text ?? ""
    }
}
