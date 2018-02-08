//
//  RestBindProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RestBindProvider : ISOnDemandTableViewInteractor {
    
    var endPoint:String!
    var keyPath:String?
    var filteredBy:String?
    var filteredFromMap:(className:String, map:Map)?
    var filteredFromParams:[String:Any]?
    
    init(tableViewConfiguration:RestBindTableViewConfiguration, filteredFromMap:(className:String, map:Map)?, filteredFromParams:[String:Any]? = nil, paginationCount:Int? = 100) {
        self.endPoint = tableViewConfiguration.endPoint
        self.keyPath = tableViewConfiguration.keyPath
        self.filteredBy = tableViewConfiguration.filteredBy
        self.filteredFromMap = filteredFromMap
        self.filteredFromParams = filteredFromParams
        super.init(paginationCount: UInt(paginationCount!))
    }
    
    override func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        var objects = [Map]()
        var params:[String:Any]?
        
        guard let url = RestBind.url else {
            NSException(name: NSExceptionName(rawValue: "Exception"), reason: "Error: You need to init class RestBind(withURL:https://)", userInfo: nil).raise()
            return
            
        }
        
        if let filteredBy = filteredBy, let tuple = filteredFromMap {
            params = [String:Any]()
            for param in filteredBy.split(separator: ",") {
                let param = String(param)
                let className = tuple.className
                let map = tuple.map
                var paramKey = param
                
                if className == param {
                    paramKey = RestBind.keyIdentificator!
                }
                
                if map.JSON[paramKey] != nil {
                    params![param] = map.JSON[paramKey] as Any
                }else {
                    print("param " + param + " not found in map")
                }
            }
        }else if let filteredFromParams = filteredFromParams {
            params = filteredFromParams
        }
        
        Alamofire.request(url + endPoint, parameters: params).responseJSON { (dataResponse:DataResponse<Any>) in
            if let results = dataResponse.result.value as? [[String:Any]] {
                for result in results {
                    let object = Map(mappingType: .fromJSON, JSON: result)
                    objects.append(object)
                }
                handler(objects,nil)
            }else if let error = dataResponse.result.error {
                handler([],error)
            }
        }
    }
    
}
