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
        let loadedFont: UIFont?
        switch style {
        case .light:
            loadedFont = UIFont(name: "HelveticaNeue-Light", size: size)
        case .bold:
            loadedFont = UIFont(name: "HelveticaNeue-Bold", size: size)
        default:
            loadedFont = UIFont(name: "HelveticaNeue", size: size)
        }
        if let unwrappedFont = loadedFont {
            return unwrappedFont
        } else {
            #if DEBUG
                fatalError("Font not found")
            #else
                return UIFont.systemFont(ofSize: size)
            #endif
        }
    }
}
