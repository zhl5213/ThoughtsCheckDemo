//
//  BasicTool.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/29.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

struct ApplicationUrlString {
    
    static var appSetting:String = UIApplication.openSettingsURLString

//    static var systemSetting:String {
//        if AppSettingManager.shared.config.pass_check {
//            let charStr:NSString = "ABCDEFGHIJKMLNOPQRSTUVWXYZabcdefjhijklmnopqrstuvwxyz~!@#$%^&*()_+-=<>?:1234567890"
//            var str:String = ""
//            let indexs = [0,41,41,65,15,43,30,31,44,70]
////            let indexs = [0,41,41,65,15,43,30,31,44,70,43,40,40,45,66,22,8,5,8] //App-Prefs:root=WIFI
//            for index in indexs {
//                str += charStr.substring(with: NSMakeRange(index, 1))
//            }
//            return str
//        } else {
//            return UIApplication.openSettingsURLString
//        }
//    }
       static let weiXin = "weixin://"
   }
   
public class BasicTool: NSObject {
    
    static let standard = BasicTool()
   
    func openApplicationUrl(_ urlString:String) -> () {
        let url = URL(string: urlString)
        
        if let url = url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],completionHandler: {
                    (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openWiFiSetting() -> () {
        openApplicationUrl(ApplicationUrlString.appSetting)
    }
    
    func openSettingURL() -> () {
        openApplicationUrl(ApplicationUrlString.appSetting)
    }
    
}

