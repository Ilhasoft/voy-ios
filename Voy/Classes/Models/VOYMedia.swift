//
//  VOYMedia.swift
//  Voy
//
//  Created by Daniel Amaral on 08/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

class VOYMedia: Mappable {
    
    var id:Int!
    var title:String!
    var media_type:String!
    var file:String!
    var thumbnail:String?
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        media_type <- map["media_type"]
        file <- map["file"]
        thumbnail <- map["thumbnail"]
    }
    
    func map() -> Map {
        return Map(mappingType: .toJSON, JSON: self.toJSON())
    }
}

