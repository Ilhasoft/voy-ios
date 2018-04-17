//
//  StringExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 21/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension String {
    public static func getIdentifier() -> String {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        let seconds = Calendar.current.component(.second, from: Date())
        return "\(day)\(month)\(year)\(hour)\(minutes)\(seconds)"
    }

    var isValidURL: Bool {
        let urlRegex = "^(https://|http://)?[a-z0-9]+([-.][a-z0-9]+)+.*$"
        return (self as NSString).range(of: urlRegex, options: .regularExpression).location != NSNotFound
    }
}
