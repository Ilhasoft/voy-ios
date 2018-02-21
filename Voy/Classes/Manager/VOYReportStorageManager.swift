//
//  VOYReportStorageManager.swift
//  Voy
//
//  Created by Daniel Amaral on 21/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYReportStorageManager: NSObject {

    static func getPendentReports() -> [[String: Any]] {
        if let reportsDictionary = UserDefaults.standard.getArchivedObject(key: "reports") as? [[String: Any]] {
            return reportsDictionary
        }
        return [[String:Any]]()
    }
    
    static func addAsPendent(report:VOYReport) {
        let defaults = UserDefaults.standard
        
        var pendentReports = getPendentReports()
        pendentReports.append(report.toJSON())
        
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: pendentReports)
        defaults.set(encodedObject, forKey: "reports")
        defaults.synchronize()
    }
    /*
    static func addPendentReportInURLCache(report:VOYReport) {
        guard let request = VOYRequestManager.lastURLRequestPendentReport else { return }
        guard let response = VOYRequestManager.lastURLResponsePendentReport else { return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: cachedResponse.data, options: [])
                    var pendingReportsArray = (jsonObject as! [String:Any])["results"] as! [[String : Any]]
                    pendingReportsArray.append(report.toJSON())
                let input = ["results":pendingReportsArray]
                var value = input
                let data = withUnsafePointer(to: &value) {
                    Data(bytes: UnsafePointer($0), count: MemoryLayout.size(ofValue: input))
                }
                let cachedURLResponse = CachedURLResponse(response: response, data: data , userInfo: nil, storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: request)
            }catch {
                print(error.localizedDescription)
            }
            
        }
    }
    */
}

