//
//  VOYLocalizable.swift
//  Voy
//
//  Created by Dielson Sales on 06/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYLocalizable {
    
    /**
     * Add item here in alphabetic order
     */
    enum LocalizedText: String {
        case error
        case hey
        case login
        case loginErrorMessage = "login_error_message"
        case ok
        case password
        case username
    }
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText) -> String {
    return NSLocalizedString(localizedText.rawValue, comment: "")
}
