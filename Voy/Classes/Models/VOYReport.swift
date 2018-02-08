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
    var media:VOYMedia!
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        theme <- map["theme"]
        name <- map["name"]
        description <- map["description"]
        media <- map["last_image"]
    }
    
}
