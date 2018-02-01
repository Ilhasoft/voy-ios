//
//  AppDelegate.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        setupWindow()
        return true
    }

    func setupAppearance() {
        UINavigationBar.appearance().tintColor = VOYConstant.Color.blue
        UINavigationBar.appearance().titleTextAttributes =  [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 16) as Any]
    }
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window!.rootViewController = loadRootScreen()
        self.window!.makeKeyAndVisible()
    }

    func loadRootScreen() -> UIViewController {
        let navigation = UINavigationController(rootViewController: VOYLoginViewController())
        return navigation
    }
}

