//
//  VOYMediaDownloadManager.swift
//  Voy
//
//  Created by Daniel Amaral on 23/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Alamofire

class VOYMediaDownloadManager {

    static let shared = VOYMediaDownloadManager()
    static var destinationPath: URL! {
        let urlPath: String? = VOYFileUtil.outputURLDirectory?.appendingPathComponent(String.getIdentifier()+".mp4")
        if let urlPath = urlPath {
            return URL(fileURLWithPath: urlPath)
        } else {
            #if DEBUG
                fatalError("Could not create output path for media")
            #endif
        }
    }

    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        return (destinationPath, [.removePreviousFile, .createIntermediateDirectories])
    }

    func download(url: String, completion: @escaping(URL?) -> Void) {
        guard let parsedURL = URL(string: url) else {
            completion(nil)
            return
        }
        let urlRequest = URLRequest(
            url: parsedURL,
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
                        if let data = try? Data(contentsOf: VOYMediaDownloadManager.destinationPath),
                           let internalResponse = response.response {
                            let cachedURLResponse = CachedURLResponse(response: internalResponse, data: data)
                            URLCache.shared.storeCachedResponse(cachedURLResponse, for: urlRequest)
                        }
                    }
                    completion(VOYMediaDownloadManager.destinationPath)
                }
        }
    }
}
