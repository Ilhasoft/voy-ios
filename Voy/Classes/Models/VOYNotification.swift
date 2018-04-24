//
//  VOYNotification.swift
//  Voy
//
//  Created by Pericles Jr on 09/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ObjectMapper

class VOYNotification: Mappable {

    var id: Int!
    var status: Int!
    var origin: Int!
    var read: Bool!
    var message: String?
    var report: VOYReport!

    init(body: String, report: VOYReport) {
        self.message = body
        self.report = report
    }

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        origin <- map["origin"]
        read <- map["read"]
        message <- map["message"]
        report <- map["report"]
    }

    func map() -> Map {
        return Map(mappingType: .toJSON, JSON: self.toJSON())
    }
}
