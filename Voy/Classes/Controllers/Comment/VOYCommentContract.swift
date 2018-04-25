//
//  VOYCommentContract.swift
//  Voy
//
//  Created by Pericles Jr on 02/03/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

protocol VOYCommentContract: AnyObject {
    func update(with viewModel: VOYCommentViewModel)
    func showCommentSentAlert()
    func setImage(image: UIImage, at position: Int)
    func showProgress()
    func hideProgress()
}
