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
        case account
        case addLink = "add_link"
        case addPhotosAndVideos = "add_photos_and_videos"
        case addReport = "add_report"
        case addTags = "add_tags"
        case alert
        case allReportsApproved = "all_reports_approved"
        case approved
        case cancel
        case change
        case close
        case comment
        case comments
        case commentSentToModeration = "comment_sent_to_moderation"
        case dateFormat = "date_format"
        case description
        case done
        case editReport = "edit_report"
        case email
        case error
        case gpsPermissionError = "gps_permission_error"
        case great
        case greatJob = "great_job"
        case hello
        case hey
        case issuesReported = "issues_reported"
        case login
        case loginErrorMessage = "login_error_message"
        case logout
        case movie
        case needGpsPermission = "need_gps_permission"
        case newPassword = "new_password"
        case next
        case noReportsYet = "no_reports_yet"
        case notApproved = "not_approved"
        case notifications
        case ok
        case outsideThemesBounds = "outside_themes_bounds"
        case password
        case pending
        case photo
        case remove
        case save
        case send
        case sendComment = "send_comment"
        case thanks
        case thanksForReporting = "thanks_for_reporting"
        case title
        case titleAndDescription = "title_and_description"
        case username
        case themesListHeader = "themes_list_header"
        case reportWasApproved = "report_was_approved"
        case commentWasApproved = "comment_was_approved"
        case reportWasNotApproved = "report_was_not_approved"
        case commentWasNotApproved = "comment_was_not_approved"
    }
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText) -> String {
    return NSLocalizedString(localizedText.rawValue, comment: "")
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText, andNumber number: Int) -> String {
    let format = localizedString(localizedText)
    return String(format: format, arguments: [number])
}
