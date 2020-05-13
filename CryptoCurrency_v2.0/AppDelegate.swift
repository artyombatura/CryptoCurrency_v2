//
//  AppDelegate.swift
//  CryptoCurrency_v2.0
//
//  Created by Artyom on 5/9/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.shared.enable = true
        
        let userdefaults = UserDefaults.standard
        
        let firstAppLoginCheck = userdefaults.value(forKey: firstAppLogin) as? Bool
        if let _ = firstAppLoginCheck {
            print("not first login")
        } else {
            userdefaults.set(true, forKey: firstAppLogin)
            userdefaults.set("USD" as Any, forKey: getInternationalCurrencyCode)
            print("first login")
        }
        
        
        let vc = CurrenciesViewController.storyboardInstance
        let navVC = UINavigationController(rootViewController: vc)
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

