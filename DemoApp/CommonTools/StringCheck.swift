//
//  StringCheck.swift
//  MiniEye
//
//  Created by user_ on 2019/7/7.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation


//class StringCheck {
//    static let countOfSMCode = 6
//    static let minCountOfPassword = 6
//    static let maxCountOfPassword = 16
//    static let countOfPhoneNumber = 11
//    /// 检查密码是否合法  6 - 16 位数字和字母
//    ///
//    /// - Parameter str: 检查的字符串
//    /// - Returns: 返回nil 表示合法， 反之不合法，内容为错误提示
//    static func check(password:String?) -> String? {
//        guard let tPassword = password else {
//            return .localized_Password_Null_Tip
//        }
//        if tPassword.count < minCountOfPassword || tPassword.count > maxCountOfPassword {
//            return String.localizedStringWithFormat(.localized_Password_Tip, minCountOfPassword,maxCountOfPassword)
//        }
////        let pattern = "[0-9]+[a-zA-Z]+[0-9a-zA-Z]*|[a-zA-Z]+[0-9]+[0-9a-zA-Z]*" //数字和字母的组合
//        let pattern = "^[0-9a-zA-Z]{\(minCountOfPassword),\(maxCountOfPassword)}$" //数字或字母
//        let regex = try? NSRegularExpression(pattern: pattern, options: [])
//        if let results = regex?.matches(in: tPassword, options: [], range: NSRange(location: 0, length: tPassword.count)), results.count != 0 {
//            return nil
//        } else {
//            return String.localizedStringWithFormat(.localized_Password_Tip, minCountOfPassword,maxCountOfPassword)
//        }
//    }
//    
//    static func isDeviceSSID(_ ssid:String) -> Bool {
//        let pattern = "^MINIEYE-[0-9a-zA-Z]{8}$"
//        let regex = try? NSRegularExpression(pattern: pattern, options: [])
//        if let results = regex?.matches(in: ssid,
//                                        options: [],
//                                        range: NSRange(location: 0, length: ssid.count)),
//            results.count != 0 {
//            return true
//        }
//        return false
//    }
//    
//    static func check(smcode:String?) -> String? {
//        guard let tCode = smcode else {
//            return .localized_Veri_Code_Null_Tip
//        }
//        if tCode.count != countOfSMCode {
//            return String.localizedStringWithFormat(.localized_Code_Tip, StringCheck.countOfSMCode)
//        }
//        let pattern = "[0-9]{6}"
//        let regex = try? NSRegularExpression(pattern: pattern, options: [])
//        if let results = regex?.matches(in: tCode, options: [], range: NSRange(location: 0, length: tCode.count)), results.count != 0 {
//            return nil
//        } else {
//            return String.localizedStringWithFormat(.localized_Code_Tip, StringCheck.countOfSMCode)
//        }
//    }
//
////    
////    static func check(phoneNumber phone:String?) -> String? {
////        var msg:String? = nil
////        guard phone != nil else {
////            msg = .localized_Phone_Number_NULL
////            print("\(msg!)")
////            return msg
////        }
////        
////        if !phone!.telephoneIsValid() {
////            msg = String.localizedStringWithFormat(.localized_Enter_Phone_Number_Tip, countOfPhoneNumber)
////            print("\(msg!)")
////            return msg
////        }
////        return msg
////    }
//    
//    
//}
