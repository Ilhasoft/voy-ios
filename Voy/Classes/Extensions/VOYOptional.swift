//
//  VOYOptional.swift
//  Voy
//
//  Created by Dielson Sales on 20/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

/**
 * Raises a fatal error in DEBUG mode if the variable is not set
 */
func assertExists<T>(optionalVar: T?) -> T? {
    if let variable = optionalVar {
        return variable
    } else {
        #if DEBUG
            fatalError("\(String(describing: optionalVar)) is null")
        #else
            return nil
        #endif
    }
}
