//
//  VOYFileUtil.swift
//  Voy
//
//  Created by Daniel Amaral on 22/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYFileUtil {

    public static var outputURLDirectory: NSString? {
        let searchPathsForDirectories = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )
        if let firstPath = searchPathsForDirectories.first {
            return firstPath as NSString
        } else {
            return nil
        }
    }

    open class func removeFile(_ fileURL: URL) {
        let filePath = fileURL.path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch let error as NSError {
                print("Can't remove file \(error.localizedDescription)")
            }
        } else {
            print("file doesn't exist")
        }
    }

    open class func writeImageFile(_ data: Data) -> String? {

        if let path = VOYFileUtil.outputURLDirectory?.appendingPathComponent("image\(String.getIdentifier()).jpg") {
            do {
                try data.write(to: URL(fileURLWithPath: path), options: [.atomic])
            } catch {
                print(error.localizedDescription)
            }
            return path
        }
        return nil
    }
}
