//
//  VOYReport.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

enum VOYReportStatus:Int {
    case approved = 1
    case pendent = 2
    case notApproved = 3
}

class VOYReport: Mappable {
    
    var id:Int?
    var theme:Int!
    var name:String!
    var description:String!
    var tags:[String]!
    var lastImage:VOYMedia!
    var files:[VOYMedia]!
    var urls:[String]!
    var media:VOYMedia!
    var created_on:String!
    var location:String!
    var status:Int?
    var cameraDataList:[VOYCameraData]?
    var removedMedias:[VOYMedia]?
    var lastNotification:String!
    var update:Bool!
    
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
        location <- map["location"]
        status <- map["status"]
        cameraDataList <- map["cameraDataList"]
        removedMedias <- map["removedMedias"]
        lastNotification <- map["last_notification"]
        update <- map["update"]
    }
    
    func map() -> Map {
        return Map(mappingType: .toJSON, JSON: self.toJSON())
    }
}
