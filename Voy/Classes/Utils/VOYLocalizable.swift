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
        case addReport = "add_report"
        case allReportsApproved = "all_reports_approved"
        case approved
        case error
        case great
        case greatJob = "great_job"
        case hello
        case hey
        case login
        case loginErrorMessage = "login_error_message"
        case noReportsYet = "no_reports_yet"
        case notApproved = "not_approved"
        case notifications
        case ok
        case password
        case pending
        case username
        case themesListHeader = "themes_list_header"
    }
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText) -> String {
    return NSLocalizedString(localizedText.rawValue, comment: "")
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText, andNumber number: Int) -> String {
    let format = localizedString(localizedText)
    return String(format: format, arguments: [number])
}
