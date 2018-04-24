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
        case areYouSure = "are_you_sure"
        case cancel
        case change
        case close
        case comments
        case commentSentToModeration = "comment_sent_to_moderation"
        case commentWasApproved = "comment_was_approved"
        case commentWasNotApproved = "comment_was_not_approved"
        case dateFormat = "date_format"
        case description
        case done
        case editReport = "edit_report"
        case externalLinks = "external_links"
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
        case logout = "logout"
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
        case periodForReportEnded = "period_for_reports_has_ended"
        case remove
        case report = "report"
        case reportedAProblem = "reported_a_problem"
        case reports = "reports"
        case reportWasApproved = "report_was_approved"
        case reportWasNotApproved = "report_was_not_approved"
        case save
        case send
        case sendComment = "send_comment"
        case thanks
        case thanksForReporting = "thanks_for_reporting"
        case themesListHeader = "themes_list_header"
        case title
        case titleAndDescription = "title_and_description"
        case username
        case youHaveNoUnapprovedReports = "you_have_no_unapproved_reports"
        case youHaveXReportsApproved = "you_have_x_reports_approved"
        case youHaveXReportsNotApproved = "you_have_x_reports_not_approved"
        case weArePreparingThisTheme = "we_are_preparing_this_theme_for_you"
        case youHaveXReportsPending = "you_have_x_reports_pending"
    }
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText) -> String {
    return NSLocalizedString(localizedText.rawValue, comment: "")
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText, andNumber number: Int) -> String {
    let format = localizedString(localizedText)
    return String(format: format, arguments: [number])
}

func localizedString(_ localizedText: VOYLocalizable.LocalizedText, andText text: String) -> String {
    let format = localizedString(localizedText)
    return String(format: format, arguments: [text])
}
