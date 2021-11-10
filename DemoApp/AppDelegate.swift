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
    static var timeBaseInfo:mach_timebase_info = mach_timebase_info.init(numer: 0, denom: 0)

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
        testMachTime()
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
    
    func testMachTime() {
        DispatchQueue.global(qos: .userInteractive).async {
            //注意，时钟滴答数单位依次为纳秒（Nanoseconds）——>微秒(microseconds)——>毫秒(millisecond)——>秒(seconds)
            let ratio = NSEC_PER_SEC
            //获取系统的time_base_info信息。swift中必须设置var变量
            let getTimeBaseInfoResult = mach_timebase_info(&AppDelegate.timeBaseInfo)
            
            //获取当前的时钟滴答数
            let currentTime = mach_absolute_time()
            
            //KERN_SUCCESS == 0，也就是result == 0 是成功的。
            print("current time is \(currentTime),timeBaseInfo is \(AppDelegate.timeBaseInfo),ratio is \(ratio),KERN_SUCCESS is \(KERN_SUCCESS),getTimeBaseInfoResult is \(getTimeBaseInfoResult)")
            
            //！！！等待到某个时刻执行
            let result = mach_wait_until(currentTime + 50 * USEC_PER_SEC)
            
            //计算等待之后的时间uint64，需要除以一个time_base_info
            let spaceTimeInt = (mach_absolute_time() - currentTime) * UInt64( AppDelegate.timeBaseInfo.numer / AppDelegate.timeBaseInfo.denom)
            
            //uint64转化为浮点型
            let floatSpaceTime = Double(spaceTimeInt)/Double(ratio)
            
            print("计划等待了1秒,mach wait result is \(result),time space is \(floatSpaceTime)")
        }
    }
}

