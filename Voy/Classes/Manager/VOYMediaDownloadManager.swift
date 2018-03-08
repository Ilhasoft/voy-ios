//
//  VOYMediaDownloadManager.swift
//  Voy
//
//  Created by Daniel Amaral on 23/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYMediaDownloadManager: NSObject {
    
    static let shared = VOYMediaDownloadManager()
    static var destinationPath = URL(
        fileURLWithPath: VOYFileUtil.outPutURLDirectory.appendingPathComponent(String.getIdentifier()+".mp4") as String
    )
    
    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        return (destinationPath, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    func download(url: String, completion: @escaping(URL?) -> Void) {

        let urlRequest = URLRequest(
            url: URL(string: url)!,
            cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad,
            timeoutInterval: 5
        )
        
        Alamofire.download(urlRequest, to: destination)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                if let statusCode = response.response?.statusCode, statusCode == 200 {
                    do {
                        let data = try Data(contentsOf: VOYMediaDownloadManager.destinationPath)
                        let cachedURLResponse = CachedURLResponse(response: response.response!, data: data)
                        URLCache.shared.storeCachedResponse(cachedURLResponse, for: urlRequest)
                    } catch {
                        print(error.localizedDescription)
                    }
                    completion(VOYMediaDownloadManager.destinationPath)
                }
        }
    }
}
