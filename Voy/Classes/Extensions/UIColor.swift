//
//  UIColorExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension UIColor {

    static var transparentBlack: UIColor { return UIColor.black.withAlphaComponent(0.5) }
    static var voyBlue: UIColor { return UIColor(hex: "00cbff") }
    static var voyGray: UIColor { return UIColor(hex: "f0f0f0") }
    static var voyLightGray: UIColor { return UIColor(hex: "e7e7e7") }
    static var voyLeafGreen: UIColor { return UIColor(hex: "7ed321") }
    static var voyLightBlue: UIColor { return UIColor(hex: "4a90e2") }
    static var voyDropDownSelectedBlue: UIColor { return UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2) }
    static var voyDropDownShadow: UIColor { return UIColor(white: 0.6, alpha: 1) }

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format: "%06x", rgb)
    }

    static func blend(from: UIColor, to: UIColor, percent: Double) -> UIColor {
        var fR: CGFloat = 0.0
        var fG: CGFloat = 0.0
        var fB: CGFloat = 0.0
        var tR: CGFloat = 0.0
        var tG: CGFloat = 0.0
        var tB: CGFloat = 0.0

        from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
        to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)

        let dR = tR - fR
        let dG = tG - fG
        let dB = tB - fB

        let rR = fR + dR * CGFloat(percent)
        let rG = fG + dG * CGFloat(percent)
        let rB = fB + dB * CGFloat(percent)

        return UIColor(red: rR, green: rG, blue: rB, alpha: 1.0)
    }
}
