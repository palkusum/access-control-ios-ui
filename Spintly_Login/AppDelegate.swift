//
//  AppDelegate.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 09/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVc = LoginVC()
        let nav = UINavigationController(rootViewController: mainVc)
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearace.barTintColor = .myColor()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        return true
    }

}

