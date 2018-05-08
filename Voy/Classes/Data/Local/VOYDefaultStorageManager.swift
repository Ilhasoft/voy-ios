//
//  VOYStorageManager.swift
//  Voy
//
//  Created by Dielson Sales on 04/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ObjectMapper

/**
 * This class saves and returns the content that is kept in the device while network is not available.
 */
class VOYDefaultStorageManager: VOYStorageManager {

    private let projectsKey = "projects"
    private let themesKey = "themes"
    private let cameraDataKey = "cameraData"

    func setProjects(_ projects: [VOYProject]) {
        storeObjects(objects: projects, usingKey: projectsKey)
    }

    func getProjects() -> [VOYProject] {
        return getObjects(usingKey: projectsKey)
    }

    // MARK: - Themes

    func setThemes(forProject project: VOYProject, _ themes: [VOYTheme]) {
        guard let projectId = project.id else { return }
        storeObjects(objects: themes, usingKey: "\(themesKey)-\(projectId)")
    }

    func getThemes(forProject project: VOYProject) -> [VOYTheme] {
        guard let projectId = project.id else { return [] }
        return getObjects(usingKey: "\(themesKey)-\(projectId)")
    }

    // MARK: - CameraData

    func getPendingCameraData() -> [[String: Any]] {
        if let cameraDataDictioanry = UserDefaults.standard.getArchivedObject(key: cameraDataKey) as? [[String: Any]] {
            return cameraDataDictioanry
        }
        return [[String: Any]]()
    }

    func removePendingCameraData(cameraData: VOYCameraData) {
        var pendentCameraDataList = getPendingCameraData()
        let index = pendentCameraDataList.index {
            if let idString = $0["id"] as? String { return idString == cameraData.id }
            return false
        }
        // TODO delete files from disk if they exist
        if let index = index {
            pendentCameraDataList.remove(at: index)
            let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendentCameraDataList)
            UserDefaults.standard.set(encodedObject, forKey: cameraDataKey)
            UserDefaults.standard.synchronize()
        }
    }

    func addPendingCameraData(cameraData: VOYCameraData, reportID: Int) {
        removePendingCameraData(cameraData: cameraData)

        if cameraData.id == nil { cameraData.id = String.generateIdentifier(from: Date()) }
        cameraData.report_id = reportID

        var pendingCameraDataList = getPendingCameraData()
        pendingCameraDataList.append(cameraData.toJSON())

        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendingCameraDataList)
        UserDefaults.standard.set(encodedObject, forKey: cameraDataKey)
        UserDefaults.standard.synchronize()
    }

    func clearPendingCameraData() {
        UserDefaults.standard.set(nil, forKey: cameraDataKey)
    }

    // MARK: - Reports

    /**
     * Retusn all the reports not yet synchronized as dictionaries.
     */
    func getPendingReports() -> [[String: Any]] {
        if let reportsDictionary = UserDefaults.standard.getArchivedObject(key: "reports") as? [[String: Any]] {
            return reportsDictionary
        }
        return [[String: Any]]()
    }

    func removePendingReport(report: VOYReport) {
        var pendingReports = getPendingReports()
        let optionalIndex = pendingReports.index {
            if let idAsInt = $0["id"] as? Int { return idAsInt == report.id }
            return false
        }
        guard let index = optionalIndex else { return }
        pendingReports.remove(at: index)
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendingReports)
        UserDefaults.standard.set(encodedObject, forKey: "reports")
        UserDefaults.standard.synchronize()
    }

    func clearPendingReports() {
        UserDefaults.standard.set(nil, forKey: "reports")
    }

    /**
     * Saves a report as a offline report to the synchronized when network is available.
     */
    func addPendingReport(_ report: VOYReport) {
        removePendingReport(report: report)

        if report.id == nil {
            let reportID = Int(String.generateIdentifier(from: Date()))
            report.id = reportID
        }

        var pendingReports = getPendingReports()
        pendingReports.append(report.toJSON())

        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendingReports)
        UserDefaults.standard.set(encodedObject, forKey: "reports")
        UserDefaults.standard.synchronize()
    }

    func clearAllOfflineData() {
        clearPendingReports()
        clearPendingCameraData()
    }

    // MARK: Private methods

    private func storeObjects<T: Mappable>(objects: [T], usingKey key: String) {
        let dictionaries: [[String: Any]] = objects.map { $0.toJSON() }
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: dictionaries)
        UserDefaults.standard.set(encodedObject, forKey: key)
        UserDefaults.standard.synchronize()
    }

    private func getObjects<T: Mappable>(usingKey key: String) -> [T] {
        var objects: [T] = []
        if let dictioanries = UserDefaults.standard.getArchivedObject(key: key) as? [[String: Any]] {
            for dictionary in dictioanries {
                if let object = T(JSON: dictionary) {
                    objects.append(object)
                }
            }
        }
        return objects
    }

}
