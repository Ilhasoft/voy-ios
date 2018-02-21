//
//  VOYRequestManager.swift
//  Voy
//
//  Created by Daniel Amaral on 15/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//
import Foundation
import Alamofire

class VOYRequestManager: NSObject {
    
    static func cacheDataFrom(url:String, parameters:inout [String:Any]) {
        
        if NetworkReachabilityManager()!.isReachable {
            var headers = [String:String]()
            headers["Cache-Control"] = "public, max-age=86400, max-stale=120"
            parameters["page"] = 1
            parameters["page_size"] = VOYConstant.API.PAGINATION_SIZE
            Alamofire.request(url, method:.get, parameters: parameters, headers: headers).responseJSON { (dataResponse:DataResponse<Any>) in
                if dataResponse.result.error == nil {
                    let cachedURLResponse = CachedURLResponse(response: dataResponse.response!, data: dataResponse.data! , userInfo: nil, storagePolicy: .allowed)
                    URLCache.shared.storeCachedResponse(cachedURLResponse, for: dataResponse.request!)
                }
                
            }
            
        }else {
            print("User haven't internet connection and don't have cached data")
        }
    }
    
}
