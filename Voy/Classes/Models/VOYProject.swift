//
//  VOYProject.swift
//  Voy
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

class VOYProject: Mappable {
    
    var id:Int!
    var name:String!
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}

