//
//  AppDelegate.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/19.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainTabBarVC = MainTabBarVC.init()
        let rootVC:UIViewController = mainTabBarVC
       
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = CommonColor.viewBG
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

