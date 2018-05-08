//
//  VOYStorageManager.swift
//  Voy
//
//  Created by Dielson Sales on 06/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYStorageManager {

    /**
     * Saves a list of projects offline.
     */
    func setProjects(_ projects: [VOYProject])

    /**
     * Returns all the projects stored offline.
     */
    func getProjects() -> [VOYProject]

    /**
     * Returns all the offline themes belonging to a specific project.
     */
    func getThemes(forProject project: VOYProject) -> [VOYTheme]

    /**
     * Stores the list of themes belonging to a determined project.
     */
    func setThemes(forProject project: VOYProject, _ themes: [VOYTheme])

    /**
     * Returns the list of all offline medias.
     */
    func getPendingCameraData() -> [[String: Any]]

    /**
     * Deletes a media from the offline list, if it exists.
     */
    func removePendingCameraData(cameraData: VOYCameraData)

    /**
     * Add a new media to the pending medias to send later.
     */
    func addPendingCameraData(cameraData: VOYCameraData, reportID: Int)

    /**
     * Deletes all medias stored offline.
     */
    func clearPendingCameraData()

    /**
     * Returns all reports saved offline. These reports are meant to be sent when there's connection later.
     */
    func getPendingReports() -> [[String: Any]]

    /**
     * Deletes a specific report from the pending list.
     */
    func removePendingReport(report: VOYReport)

    /**
     * Deletes all reports form the pending list.
     */
    func clearPendingReports()

    /**
     * Adds a new report to the pending list to be sent when there's connection later.
     */
    func addPendingReport(_ report: VOYReport)

    /**
     * Erases all content stored as offline data.
     */
    func clearAllOfflineData()
}
