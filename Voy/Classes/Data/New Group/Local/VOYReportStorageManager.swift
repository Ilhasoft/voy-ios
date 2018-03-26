//
//  VOYReportStorageManager.swift
//  Voy
//
//  Created by Daniel Amaral on 21/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportStorageManager {

    func getPendentReports() -> [[String: Any]] {
        if let reportsDictionary = UserDefaults.standard.getArchivedObject(key: "reports") as? [[String: Any]] {
            return reportsDictionary
        }
        return [[String: Any]]()
    }

    func removeFromStorageAfterSave(report: VOYReport) {
        var pendentReports = getPendentReports()
        let index = pendentReports.index {
            if let idAsInt = $0["id"] as? Int { return idAsInt == report.id }
            return false
        }
        if let index = index {
            pendentReports.remove(at: index)
            let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendentReports)
            UserDefaults.standard.set(encodedObject, forKey: "reports")
            UserDefaults.standard.synchronize()
        }
    }

    static func clearPendentReports() {
        UserDefaults.standard.set(nil, forKey: "reports")
    }

    func addAsPendent(report: VOYReport) {

        var pendentReports = getPendentReports()

        let index = pendentReports.index {
            if let idAsInt = $0["id"] as? Int { return idAsInt == report.id }
            return false
        }

        if let index = index {
            pendentReports.remove(at: index)
        }

        let reportID = Int(String.getIdentifier())
        report.id = reportID
        pendentReports.append(report.toJSON())

        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendentReports)
        UserDefaults.standard.set(encodedObject, forKey: "reports")
        UserDefaults.standard.synchronize()
    }
}
