//
//  AppDelegate.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/19.
//

import UIKit
import SQLite3
import System

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
//        subThreadDeadLock()
        let result = [123].sorted(by:<)
        let callStackReturnAddress = Thread.callStackReturnAddresses
        let callSymblos = Thread.callStackSymbols
//        for callAddress in callStackReturnAddress {
//            print("address is \(callAddress.int64Value)\n")
//        }
//        print("---------\n")
//        for symblo in callSymblos {
//            print("call symbol is \(symblo)\n")
//        }
        return true
    }
    
    let serialQueue = DispatchQueue.init(label: "test", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    func subThreadDeadLock() -> () {
     
        serialQueue.async {
            print("dead lock will happen")
            var value = 0
            while true {
                value += 1
                print("is unlimit cycle,value is \(value)")
            }
        }
    }

}

