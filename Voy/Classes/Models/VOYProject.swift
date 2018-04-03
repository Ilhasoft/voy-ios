//
//  VOYProject.swift
//  Voy
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

class VOYProject: Mappable {

    var id: Int!
    var name: String!

    init() {
    }

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }

    static func activeProject() -> VOYProject? {
        var project: VOYProject?
        if let projectDictionary = UserDefaults.standard.getArchivedObject(key: "project") as? [String: Any] {
            project = VOYProject(JSON: projectDictionary)
        }
        return project
    }

    static func setActiveProject(project: VOYProject) {
        let defaults = UserDefaults.standard
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: project.toJSON())
        defaults.set(encodedObject, forKey: "project")
        defaults.synchronize()
    }

    func map() -> Map {
        return Map(mappingType: .toJSON, JSON: self.toJSON())
    }
}
