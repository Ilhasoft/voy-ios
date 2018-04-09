//
//  VOYLoginContract.swift
//  Voy
//
//  Created by Pericles Jr on 01/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYLoginContract: class {
    func startProgressIndicator()
    func stopProgressIndicator()
    func redirectController()
    func presentErrorAlert()
}
