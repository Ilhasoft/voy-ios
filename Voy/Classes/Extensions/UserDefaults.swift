//
//  UserDefaultsExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ObjectMapper

extension UserDefaults {
    public func getArchivedObject(key: String) -> Any? {
        var any: Any?
        if let encodedData = self.object(forKey: key) as? Data {
            any = NSKeyedUnarchiver.unarchiveObject(with: encodedData)
        }
        return any
    }
    
}
