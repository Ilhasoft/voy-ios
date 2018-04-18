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

    open class func removeFile(with fileName: String) {
        if let completeFilePath = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) {
            let filePath = URL(fileURLWithPath: completeFilePath).path
            let fileManager = FileManager.default

            if fileManager.fileExists(atPath: filePath) {
                try? fileManager.removeItem(atPath: filePath)
            }
        }
    }

    open class func writeImageFile(_ data: Data) -> String? {
        let fileName = "image\(String.getIdentifier()).jpg"
        if let path = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) {
            try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
            return fileName
        }
        return nil
    }
}
