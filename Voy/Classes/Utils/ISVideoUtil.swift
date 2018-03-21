//
//  URVideoUtil.swift
//  IlhasoftCore
//
//  Created by Daniel Amaral on 02/02/16.
//  Copyright © 2016 ilhasoft. All rights reserved.
//

import UIKit
import AVFoundation

open class ISVideoUtil {
    
    static open func compressVideo(inputURL: URL, completion:@escaping (_ success: Bool, _ outputURL: URL?) -> Void) {
        
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(
            asset: urlAsset,
            presetName: AVAssetExportPresetMediumQuality
            ) else { return }
        
        let fileName = inputURL.lastPathComponent.replacingOccurrences(
            of: ".MOV",
            with: "\(String.getIdentifier()).mp4"
        )
        guard let outputDirectory = VOYFileUtil.outputURLDirectory?.appendingPathComponent(fileName) else {
            return
        }
        exportSession.outputURL = URL(fileURLWithPath: outputDirectory)
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputFileType = AVFileType.mp4
        exportSession.exportAsynchronously { () -> Void in
            if exportSession.status == AVAssetExportSessionStatus.completed {
                completion(true, URL(fileURLWithPath: outputDirectory))
            } else {
                completion(false, nil)
            }
            
        }
    }
    
    open class func generateThumbnail(_ url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let image = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg = UIImage(cgImage: image)
            return frameImg
        } catch let error as NSError {
            print("error on generate image thumbnail \(error.localizedDescription)")
            return nil
        }
    }
    
}
