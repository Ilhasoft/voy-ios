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
    
    var id: String!
    var report_id: Int!
    var type: VOYMediaType!
    var image: UIImage?
    var thumbnail: UIImage?
    var thumbnailPath: String?
    var path: String!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        report_id <- map["report_id"]
        type <- map["type"]
        image <- map["image"]
        thumbnail <- map["thumbnail"]
        thumbnailPath <- map["thumbnailPath"]
        path <- map["path"]
    }
    
    init(image: UIImage?, thumbnail: UIImage?, thumbnailPath: URL?, path: URL!, type: VOYMediaType) {
        self.id = String.getIdentifier()
        self.thumbnail = thumbnail
        if let thumbnailPath = thumbnailPath {
            self.thumbnailPath = thumbnailPath.path
        }
        self.image = image
        self.path = path.path
        self.type = type
        
    }
    
}
