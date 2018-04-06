//
//  VOYStorageManager.swift
//  Voy
//
//  Created by Dielson Sales on 04/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

/**
 * This class saves and returns the content that is kept in the device while network is not available.
 */
class VOYDefaultStorageManager: VOYStorageManager {

    // MARK: - CameraData

    func getPendingCameraData() -> [[String: Any]] {
        if let cameraDataDictioanry = UserDefaults.standard.getArchivedObject(key: "cameraData") as? [[String: Any]] {
            return cameraDataDictioanry
        }
        return [[String: Any]]()
    }

    func removeFromPendingList(cameraData: VOYCameraData) {
        var pendentCameraDataList = getPendingCameraData()
        let index = pendentCameraDataList.index {
            if let idString = $0["id"] as? String { return idString == cameraData.id }
            return false
        }
        if let index = index {
            pendentCameraDataList.remove(at: index)
            let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendentCameraDataList)
            UserDefaults.standard.set(encodedObject, forKey: "cameraData")
            UserDefaults.standard.synchronize()
        }
    }

    func addAsPending(cameraData: VOYCameraData, reportID: Int) {

        var pendentCameraDataList = getPendingCameraData()

        let index = pendentCameraDataList.index {
            if let idString = $0["id"] as? String { return idString == cameraData.id }
            return false
        }

        if let index = index {
            pendentCameraDataList.remove(at: index)
        }

        let cameraDataID = String.getIdentifier()
        cameraData.id = cameraDataID
        cameraData.report_id = reportID
        pendentCameraDataList.append(cameraData.toJSON())

        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendentCameraDataList)
        UserDefaults.standard.set(encodedObject, forKey: "cameraData")
        UserDefaults.standard.synchronize()
    }

    func clearStoredCameraData() {
        UserDefaults.standard.set(nil, forKey: "cameraData")
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

    func removeFromPendingList(report: VOYReport) {
        var pendentReports = getPendingReports()
        let index = pendentReports.index {
            if let idAsInt = $0["id"] as? Int { return idAsInt == report.id }
            return false
        }
        guard let unwrappedIndex = index else { return }
        pendentReports.remove(at: unwrappedIndex)
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendentReports)
        UserDefaults.standard.set(encodedObject, forKey: "reports")
        UserDefaults.standard.synchronize()
    }

    func clearPendentReports() {
        UserDefaults.standard.set(nil, forKey: "reports")
    }

    /**
     * Saves a report as a offline report to the synchronized when network is available.
     */
    func addPendingReport(_ report: VOYReport) {
        var pendingReports = getPendingReports()

        let index = pendingReports.index {
            if let idAsInt = $0["id"] as? Int { return idAsInt == report.id }
            return false
        }

        if let index = index {
            pendingReports.remove(at: index)
        }

        if report.id == nil {
            let reportID = Int(String.getIdentifier())
            report.id = reportID
        }

        pendingReports.append(report.toJSON())

        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendingReports)
        UserDefaults.standard.set(encodedObject, forKey: "reports")
        UserDefaults.standard.synchronize()
    }

    func clearAllStoredData() {
        clearPendentReports()
        clearStoredCameraData()
    }

}
