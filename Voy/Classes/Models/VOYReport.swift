//
//  VOYReport.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

class VOYReport: Mappable {
    
    var id:Int!
    var theme:Int!
    var name:String!
    var description:String!
    var tags:[String]!
    var lastImage:VOYMedia!
    var files:[VOYMedia]!
    var urls:[String]!
    var media:VOYMedia!
    var created_on:String!
    var cameraData:[VOYCameraData]?
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        theme <- map["theme"]
        name <- map["name"]
        description <- map["description"]
        lastImage <- map["last_image"]
        files <- map["files"]
        urls <- map["urls"]
        created_on <- map["created_on"]
        tags <- map["tags"]
    }
    
    func map() -> Map {
        return Map(mappingType: .toJSON, JSON: self.toJSON())
    }
}
