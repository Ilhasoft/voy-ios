//
//  VOYCameraData.swift
//  Voy
//
//  Created by Daniel Amaral on 19/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//
import UIKit
import ObjectMapper

class VOYCameraData: Mappable {
    
    var id:String!
    var type:VOYMediaType!
    var image:UIImage?
    var path:URL?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        image <- map["image"]
        path <- map["path"]
    }
    
    init(image:UIImage?, path:URL?, type:VOYMediaType) {
        self.id = String.getIdentifier()
        self.image = image
        self.path = path
        self.type = type
        
    }
    
}
