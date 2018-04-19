//
//  VOYThemesContract.swift
//  Voy
//
//  Created by Dielson Sales on 19/04/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYThemesContract: AnyObject {
    func update(with viewModel: VOYThemesViewModel)
    func showProgress()
    func dismissProgress()
}
