//
//  AppDelegate.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DropDown
import DataBindSwift
import SlideMenuControllerSwift
import NVActivityIndicatorView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        setupWindow()        
        URLCache.shared = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        return true
    }

    func setupAppearance() {
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulse
        UINavigationBar.appearance().tintColor = UIColor.voyBlue
        UINavigationBar.appearance().titleTextAttributes =  [NSAttributedStringKey.font: UIFont.helveticaNeue(withSize: 16, andStyle: .normal) as Any]
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor.white
        appearance.selectionBackgroundColor = UIColor.voyDropDownSelectedBlue
        appearance.cornerRadius = 17
        appearance.shadowColor = UIColor.voyDropDownShadow
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 10
        appearance.animationduration = 0.25
        appearance.textColor = .black
        appearance.textFont = UIFont.helveticaNeue(withSize: 14, andStyle: .normal)
    }
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window!.rootViewController = loadRootScreen()
        self.window!.makeKeyAndVisible()
    }

    func loadRootScreen() -> UIViewController {
        if VOYUser.activeUser() != nil {
            let navigationController = UINavigationController(rootViewController: VOYThemeListViewController())
            let slideMenuController = SlideMenuController(mainViewController: navigationController, rightMenuViewController: VOYNotificationViewController())
            return slideMenuController
        }else {
            let navigation = UINavigationController(rootViewController: VOYLoginViewController())
            return navigation
        }
    }
}

