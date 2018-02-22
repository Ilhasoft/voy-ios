//
//  VOYFileUtil.swift
//  Voy
//
//  Created by Daniel Amaral on 22/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

class VOYFileUtil: NSObject {
    public static let outPutURLDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
    
    open class func removeFile(_ fileURL: URL) {
        let filePath = fileURL.path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            }catch let error as NSError {
                print("Can't remove file \(error.localizedDescription)")
            }
            
        }else{
            print("file doesn't exist")
        }
    }
    
    open class func writeImageFile(_ data:Data) -> String{
        
        let path = VOYFileUtil.outPutURLDirectory.appendingPathComponent("image.jpg")
        
        VOYFileUtil.removeFile(URL(string: path)!)
        
        if ((try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil) == true {
            print("file available")
        }
        
        return path
    }
}
