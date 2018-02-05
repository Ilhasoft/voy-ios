//
//  ISOndemandTableViewExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

extension ISOnDemandTableView {
    func insert(object: NSObject, at index: Int) {
        DispatchQueue.main.async {
            self.interactor?.objects.insert(object, at: index)
            self.beginUpdates()
            self.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.endUpdates()
        }
    }
}

