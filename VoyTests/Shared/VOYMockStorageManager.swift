//
//  VOYMockStorageManager.swift
//  VoyTests
//
//  Created by Dielson Sales on 07/05/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import XCTest
@testable import Voy

/**
 * Mocks the smartphone storage class. This class actually saves everything in memory.
 */
class VOYMockStorageManager: VOYStorageManager {

    private var projects: [VOYProject] = []
    private var themes: [Int: [VOYTheme]] = [:]
    private var pendingCameraData: [[String: Any]] = []
    private var pendingReports: [[String: Any]] = []

    func setProjects(_ projects: [VOYProject]) {
        self.projects = projects
    }

    func getProjects() -> [VOYProject] {
        return projects
    }

    func getThemes(forProject project: VOYProject) -> [VOYTheme] {
        return themes[project.id] ?? []
    }

    func setThemes(forProject project: VOYProject, _ themes: [VOYTheme]) {
        self.themes[project.id] = themes
    }

    func getPendingCameraData() -> [[String: Any]] {
        return pendingCameraData
    }

    func removePendingCameraData(cameraData: VOYCameraData) {
        let index = pendingCameraData.index {
            if let idString = $0["id"] as? String { return idString == cameraData.id }
            return false
        }
        if let index = index {
            pendingCameraData.remove(at: index)
        }
    }

    func addPendingCameraData(cameraData: VOYCameraData, reportID: Int) {
        removePendingCameraData(cameraData: cameraData)
        if cameraData.id == nil { cameraData.id = String.generateIdentifier(from: Date()) }
        cameraData.report_id = reportID
        pendingCameraData.append(cameraData.toJSON())
    }

    func clearPendingCameraData() {
        pendingCameraData = []
    }

    func getPendingReports() -> [[String: Any]] {
        return pendingReports
    }

    func removePendingReport(report: VOYReport) {
        let index = pendingReports.index {
            if let idAsInt = $0["id"] as? Int { return idAsInt == report.id }
            return false
        }
        if let index = index {
            pendingReports.remove(at: index)
        }
    }

    func clearPendingReports() {
        pendingReports = []
    }

    func addPendingReport(_ report: VOYReport) {
        removePendingReport(report: report)
        pendingReports.append(report.toJSON())
    }

    func clearAllOfflineData() {
        clearPendingCameraData()
        clearPendingReports()
    }
}
