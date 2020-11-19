//
//  NetworkUrls.swift
//  MiniEye
//
//  Created by 朱慧林 on 2020/7/7.
//  Copyright © 2020 MINIEYE. All rights reserved.
//

import Foundation


struct MEHost {
    enum Environment:Int {
        case develop = 0
        case test = 1
        case product = 2
    }
    
    static var ServerEnv:Environment = .test
    
    /// passport服务器 登录、重置密码、绑定手机号使用此服务器
    static var accountHost:String {
        get {
            let dev = "https://login.minieye.cc:15931"
            let test = "https://login.minieye.cc"
            let product = "https://login.minieye.cc"
            return [dev,test,product][MEHost.ServerEnv.rawValue]
        }
    }
    
    static let cloudHostName:String = URL.init(string: host)!.host!
///  设备的域名，不包括http协议前缀，其实是ip地址
    static let deviceHostName:String = URL.init(string: deviceHost)!.host!
    
    /// 业务系统使用此服务器
    static var host:String {
        get {
            let dev = "https://argus-test.minieye.tech:15502"
            let test = "https://argus-test.minieye.tech"
            let product = "https://argus.minieye.tech"
            return [dev,test,product][MEHost.ServerEnv.rawValue]
        }
    }
    
    /// 连接设备使用此服务器
    static var deviceHost:String {
        get {
            let host = "http://192.168.42.1:8080"
            return host
        }
    }
    
    static var deviceRTSPHost:String {
        get {
            let host = "rtsp://192.168.42.1/tmp/SD0/"
            return host
        }
    }
    
    static var deviceC8Host:String {
        get {
            let host = "http://192.168.42.1:12306"
            return host
        }
    }

    
    static let uid:String = UIDevice.current.identifierForVendor!.uuidString
}

struct MeAppUrl {
    private static let appleAppId = "1486553938"
    static let userProtocolUrl = "https://cdn.minieye.tech/agreement/UserAgreement.html"
    static let privacyPolicyUrl = "https://cdn.minieye.tech/agreement/PrivacyPolicy.html"
    static let appleStoreUrl = "https://apps.apple.com/cn/app/id" + appleAppId
    
    static let companyUrl = "https://www.minieye.cc"
    static let c1Url = "https://c.minieye.cc"

    static var deviceHelpUrl:String {
        get {
            let dev = MEHost.host + "/argus-client/pages/manual/list/6"
            let test = dev
            let product = MEHost.host + "/argus-client/pages/manual/list/6"
            return [dev,test,product][MEHost.ServerEnv.rawValue]
        }
    }
    
    static var accountHelpUrl:String {
        get {
            let dev = MEHost.host + "/argus-client/pages/manual/list/7"
            let test = dev
            let product = MEHost.host + "/argus-client/pages/manual/list/7"
            return [dev,test,product][MEHost.ServerEnv.rawValue]
        }
    }

}
