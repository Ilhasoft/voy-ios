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
    var thumbnailFileName: String?
    var fileName: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        report_id <- map["report_id"]
        type <- map["type"]
        image <- map["image"]
        thumbnail <- map["thumbnail"]
        thumbnailFileName <- map["thumbnailPath"]
        fileName <- map["path"]
    }

    init(image: UIImage?, thumbnail: UIImage?, thumbnailFileName: String?, fileName: String?, type: VOYMediaType) {
        self.id = String.generateIdentifier(from: Date())
        self.thumbnail = thumbnail
        self.thumbnailFileName = thumbnailFileName
        self.image = image
        self.fileName = fileName
        self.type = type

    }

}
