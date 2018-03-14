//
//  UIViewControllerExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 05/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static public func switchRootViewController(_ rootViewController: UIViewController, animated: Bool,
                                                transition: UIViewAnimationOptions = .transitionFlipFromLeft,
                                                completion: (() -> Void)?) {
        let window = UIApplication.shared.keyWindow
        if animated {
            UIView.transition(with: window!, duration: 0.5, options: transition, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window!.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                if completion != nil {
                    completion!()
                }
            })
        } else {
            window!.rootViewController = rootViewController
        }
    }
    
    static public func rootViewController() -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}
