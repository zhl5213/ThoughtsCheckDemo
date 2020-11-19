//
//  LogManager.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/16.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit
//import Bugly

enum LogLevel:Int {
    case testClose
    case debug
    case release
}

class LogTool: BasicTool {

    let buglyAppID = "02ee6342cc"

    static var logLevel = LogLevel.debug

    static let shared = LogTool.init()
    
//    func startExceptionLogCollect() -> () {
//        let configure = BuglyConfig.init()
//        configure.reportLogLevel = .warn
//        configure.deviceIdentifier = MEHost.uid
//        configure.blockMonitorEnable = true
//
//        Bugly.start(withAppId: buglyAppID, config: configure)
//        print_Debug(message: "startExceptionLogCollect")
//    }

}
