//
//  VOYComment.swift
//  Voy
//
//  Created by Daniel Amaral on 26/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

class VOYComment: Mappable {

    var id: Int!
    var text: String!
    var createdBy: VOYUser!
    var createdOn: String!
    var modifiedOn: String!
    var report: Int!

    init(text: String, reportID: Int) {
        self.text = text
        self.report = reportID
    }

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        text <- map["text"]
        createdBy <- map["created_by"]
        createdOn <- map["created_on"]
        modifiedOn <- map["modified_on"]
        report <- map["report"]
    }

    func map() -> Map {
        return Map(mappingType: .toJSON, JSON: self.toJSON())
    }
}
