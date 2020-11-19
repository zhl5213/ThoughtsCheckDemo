//
//  DebugFunctions.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/9.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation
import os

func print_Debug(file:String=#file,function:String=#function,line:Int=#line,object:Any? = nil,message:String,prlogLevel:LogLevel = .debug) -> () {
    
    guard LogTool.logLevel.rawValue <= LogLevel.debug.rawValue else {
        return
    }
    
    if prlogLevel.rawValue < LogLevel.debug.rawValue {
        return
    }
    
//    if file == "HTTPNetworkTool.swift" || file == "DeviceManagementManger.swift" || file == "WebSocketTool.swift" {
//         return
//    }
    
    
    let date = Date.init(timeIntervalSinceNow: 0)
    let dateFormat = DateFormatter.init()
    dateFormat.dateFormat = "YYYY-MM-dd  HH:mm:ss:SSS"
    let dateString = dateFormat.string(from: date)
    
//    let addMessage = withVaList(args) { return NSString.init(format: message, arguments: $0)}
    var className:String = ""
    
    if let _ = object {
        className = String(describing: type(of: object!))
    }
    
    print("Debug info: File [\((file as NSString).lastPathComponent)],Line \(line),Type [\(className)],Function [\(function)],\n message at \(dateString)：\(message)")
}
