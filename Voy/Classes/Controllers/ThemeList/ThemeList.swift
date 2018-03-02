//
//  ThemeList.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol ThemeList {
    func getMyProjects(completion:@escaping(_ projects:[VOYProject], _ error: Error?) -> Void)
}

