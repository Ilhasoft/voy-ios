//
//  VOYCameraDataStorageManager.swift
//  Voy
//
//  Created by Daniel Amaral on 22/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYCameraDataStorageManager {

    func getPendentCameraDataList() -> [[String: Any]] {
        if let cameraDataDictioanry = UserDefaults.standard.getArchivedObject(key: "cameraData") as? [[String: Any]] {
            return cameraDataDictioanry
        }
        return [[String: Any]]()
    }

    func removeFromStorageAfterSave(cameraData: VOYCameraData) {
        var pendentCameraDataList = getPendentCameraDataList()
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

    func addAsPendent(cameraData: VOYCameraData, reportID: Int) {

        var pendentCameraDataList = getPendentCameraDataList()

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
}
