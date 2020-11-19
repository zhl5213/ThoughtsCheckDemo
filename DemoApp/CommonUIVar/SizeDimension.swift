//
//  SizeDimension.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/8.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation


import UIKit

//MARK: - system UI parameter -

let ScreenW = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width

var isIPhoneXSerial:Bool {
    return SafeStatusBarHeight == 44.0
}

let SafeStatusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height

var SafeBottomMargin : CGFloat {
    return isIPhoneXSerial ? 34 : 0
}


//StatusBarH,iphoneX为44，其他的是20
let StatusBarH  = UIApplication.shared.statusBarFrame.height
let NavigationBarH : CGFloat = 44.0
let TabBarH : CGFloat = 49.0
let ScaleWToiPhoneX = UIScreen.main.bounds.size.width / 414
let ScreenCompareToSix = ScreenW/375.0


//MARK: - Common UI parameter -

struct CommonDimension {
    static let seperatorheight:CGFloat = 1
///  数值为50
    static let buttonHeight:CGFloat = 50
    static let smallCornerRadius:CGFloat = 5
///  5
    static let smallContentVerticalMargin:CGFloat = 5
/// 30
    static let contentHorizitalMargin:CGFloat = 30
/// 15
    static let smallContentHorizitalMargin:CGFloat = 15
///20
    static let mediumContentHorizitalMargin:CGFloat = 20
    static let barButtonFrame = CGRect(x: 0, y: 0, width: 60, height: 44)
    static let topMagin:CGFloat = 30
}

//deprecated
let defaultButtonHeight:CGFloat = 50
let defaultButtonCornerRadius:CGFloat = 5

/// 20
let defaultCellContentHorizitalMargin:CGFloat = 20
let homePageCellHorizitalMargin:CGFloat = 15


let vedioPlayerWidth = (ScreenW-homePageCellHorizitalMargin*2-5)/2
let vedioPlayerHeight = vedioPlayerWidth * 9/16



class UIUtility: NSObject {
    
    /** name:16进制获取颜色 */
    static func colorConversionHex(hexString:NSString , alpha:CGFloat)->UIColor {
        
        var Str :NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        
        if hexString.hasPrefix("#"){
            Str=(hexString as NSString).substring(from: 1) as NSString
        }
        let ZSJ_StrRed = (Str as NSString ).substring(to: 2)
        let ZSJ_StrGreen = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
        let ZSJ_StrBlue = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string:ZSJ_StrRed).scanHexInt32(&r)
        Scanner(string: ZSJ_StrGreen).scanHexInt32(&g)
        Scanner(string: ZSJ_StrBlue).scanHexInt32(&b)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        
    }
    
    
}
