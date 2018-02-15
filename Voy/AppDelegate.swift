//
//  AppDelegate.swift
//  Voy
//
//  Created by Daniel Amaral on 30/01/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import DropDown
import RestBind
import SlideMenuControllerSwift
import NVActivityIndicatorView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        setupWindow()        
        URLCache.shared = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        _ = RestBind(withURL: VOYConstant.API.URL, keyIdentificator: "id", paginationCount: VOYConstant.API.PAGINATION_SIZE)
        return true
    }

    func setupAppearance() {
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulse
        UINavigationBar.appearance().tintColor = VOYConstant.Color.blue
        UINavigationBar.appearance().titleTextAttributes =  [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 16) as Any]
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 17
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 10
        appearance.animationduration = 0.25
        appearance.textColor = .black
        appearance.textFont = UIFont(name: "HelveticaNeue", size: 14)!
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

