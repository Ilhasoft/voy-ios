//
//  UIFont.swift
//  Voy
//
//  Created by Dielson Sales on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension UIFont {
  
    enum FontStyle {
        case light
        case bold
        case normal
    }
  
    static func helveticaNeue(withSize size: CGFloat, andStyle style: FontStyle) -> UIFont {
        switch style {
        case .light:
            return UIFont(name: "HelveticaNeue-Light", size: size)!
        case .bold:
            return UIFont(name: "HelveticaNeue-Bold", size: size)!
        default:
            return UIFont(name: "HelveticaNeue", size: size)!
        }
    }
}
