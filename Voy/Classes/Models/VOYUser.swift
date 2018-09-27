//
//  VOYUser.swift
//  Voy
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

class VOYUser: Mappable {

    var id: Int!
    var first_name: String!
    var last_name: String!
    var password: String!
    var avatar: String!
    var email: String!
    var username: String!
    var is_mapper: Bool!
    var is_admin: Bool!
    var authToken: String!

    init() {
    }

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        avatar <- map["avatar"]
        email <- map["email"]
        username <- map["username"]
        is_mapper <- map["is_mapper"]
        is_admin <- map["is_admin"]
        authToken <- map["authToken"]
    }

    static func activeUser() -> VOYUser? {
        var user: VOYUser?
        if let userDictionary = UserDefaults.standard.getArchivedObject(key: "user") as? [String: Any] {
            user = VOYUser(JSON: userDictionary)
            user?.avatar = user?.avatar.replacingOccurrences(of: "http", with: "https")
        }
        return user
    }

    static func deactiveUser() {
        UserDefaults.standard.removeObject(forKey: "user")
    }

    static func setActiveUser(user: VOYUser) {
        let defaults = UserDefaults.standard

        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: user.toJSON())
        defaults.set(encodedObject, forKey: "user")
        defaults.synchronize()
    }
}
