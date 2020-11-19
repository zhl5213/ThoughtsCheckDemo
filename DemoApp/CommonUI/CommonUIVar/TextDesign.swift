//
//  TextDesign.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/8.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation
import UIKit

// Color

struct CommonColor {
    
    static let black:UIColor = UIColor.init(white: 0, alpha: 1)
    static let grayText:UIColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
    static let text:UIColor = UIColor(red: 51.0/255.0, green: 60.0/255.0, blue: 79.0/255.0, alpha: 1)
    static let systemBGGray:UIColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
    static let shadowColor:UIColor = UIColor.colorWithRGBA(r: 184, g: 189, b: 212, alpha: 0.9)
    static let buttonTitleColor = UIColor(red: 51.0 / 255.0, green: 60.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    static let commonShadow:UIColor = UIColor.colorWithRGBA(r: 219, g: 226, b: 255, alpha: 0.3)
//    static let mainColor:UIColor = UIColor(red: 115/255, green: 144/255, blue: 233/255, alpha: 1)
    static let buttonDestructiveBG:UIColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
    static let buttonDisableBG:UIColor = UIColor.init(red: 150/255, green: 154/255, blue: 168/255, alpha: 1)
    static let buttonBorder:UIColor = UIColor(red: 197 / 255.0, green: 202 / 255.0, blue: 213 / 255.0, alpha: 1.0)
    static let searchBarBG:UIColor =  UIColor.colorWithHex(hex: 0xF6F5F5)
//    static let blue:UIColor = UIColor.init(red: 62.0 / 255.0, green: 119.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    static let viewBG:UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let tabBarBG:UIColor = UIColor(red: 246.0 / 255.0, green: 247.0 / 255.0, blue: 249.0 / 255.0, alpha: 1)
    static let mainFont:UIColor = UIColor.colorWithHex(hex: 0x4e77ed)
    
    
//-----------最新版UI颜色
    static let seperatorLine:UIColor = UIColor(white: 0, alpha: 0.1)
    ///6d8ff0
    static let blue = UIColor.colorWithHex(hex: 0x6d8ff0)
///0x191919
    static let titleColor = UIColor.colorWithHex(hex: 0x191919)
/// 0x323235
    static let subTitleColor = UIColor.colorWithHex(hex: 0x323235)
    /// grayTitleColor
    static let contentColor = UIColor.colorWithHex(hex: 0x3c3c3c)
    ///545459
    static let grayTitleColor = UIColor.colorWithHex(hex: 0x545459)
    ///747474
    static let grayButtonColor = UIColor.colorWithHex(hex: 0x747474)
///9f9f9f
    static let detailColor = UIColor.colorWithHex(hex: 0x9f9f9f)
    ///6d6f77
    static let tipColor = UIColor.colorWithHex(hex: 0x6D6F77)
    static let redColor = UIColor.colorWithHex(hex: 0xfa7272)
    static let warningColor = UIColor.colorWithHex(hex: 0xFFD800)
    /// 0x4E77ED
    static let mainColor = UIColor.colorWithHex(hex: 0x4E77ED)
    /// 0xECECEC
    static let grayColor = UIColor.colorWithHex(hex: 0xECECEC)
    static let tabColor = UIColor.colorWithHex(hex: 0x444444)
    static let tabHighlightColor = UIColor.colorWithHex(hex: 0x4e77ed)
    static let avatorShadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7)
/// 0xBACCFF
    static let mainDisableColor = UIColor.colorWithHex(hex: 0xBACCFF)
/// 0x9F9F9F
    static let explainBG:UIColor =  UIColor.colorWithHex(hex: 0x9F9F9F)
    static let sliderMinTintColor:UIColor = .colorWithHex(hex: 0xBABABA)
    static let sliderMaxTintColor:UIColor = .colorWithHex(hex: 0xDEDEDE)
    
    static let colors = [UIColor.colorWithHex(hex: 0x6E4DFB),
                         UIColor.colorWithHex(hex: 0xE187FE),
                         UIColor.colorWithHex(hex: 0x1847CB),
                         UIColor.colorWithHex(hex: 0x6D8FF0),
                         UIColor.colorWithHex(hex: 0x86EAFF),
                         UIColor.colorWithHex(hex: 0x4E77ED)]

    static let collectionViewBG:UIColor = UIColor.colorWithHex(hex: 0xf5f5f5)
    static let adasMarkColor:UIColor = UIColor.colorWithHex(hex: 0x668bff)
    static let myCaptureMarkColor:UIColor = UIColor.colorWithHex(hex: 0x17f5ff)
}



struct CommonFont {
    
    ///  UIFont.systemFont(ofSize: 16)
    static let content:UIFont = UIFont.systemFont(ofSize: 16)
    ///  UIFont.systemFont(ofSize: 14)
    static let detail:UIFont = UIFont.systemFont(ofSize: 14)
    static let tip:UIFont = UIFont.systemFont(ofSize: 12)
    static let text:UIFont = UIFont.systemFont(ofSize: 20)
    static let title:UIFont = UIFont.systemFont(ofSize: 18)
    static let titleBold:UIFont = UIFont.boldSystemFont(ofSize: 18)
    static let bigTitle:UIFont = UIFont.boldSystemFont(ofSize: 22)
    ///  UIFont.systemFont(ofSize: 10)
    static let bdge:UIFont = UIFont.systemFont(ofSize: 10)
    
//-------------最新版UI字体
    
    static let hugeFont = UIFont.regularAppFont(ofSize: 27)
    static let bigFont = UIFont.regularAppFont(ofSize: 25)
    static let commonTitleFont = UIFont.regularAppFont(ofSize: 16)
    static let subTitleFont = UIFont.regularAppFont(ofSize: 17)
    static let contentFont = UIFont.regularAppFont(ofSize: 15)
    static let detailFont = UIFont.regularAppFont(ofSize: 13)
    static let smallFont = UIFont.regularAppFont(ofSize: 12)

    
}
// Font

extension UIFont {
    /// 苹方SC regular
    static func regularAppFont(ofSize size:CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Regular", size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func lightAppFont(ofSize size:CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Light", size: size)
        return font  ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
    
    static func thinAppFont(ofSize size:CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Thin", size: size)
        return font ?? UIFont.systemFont(ofSize: size, weight: .thin)
    }
    
/// 苹方中黑体
    static func mediumAppFont(ofSize size:CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Medium", size: size)
        return font ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }

    static func boldAppFont(ofSize size:CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Semibold", size: size)
        return font ?? UIFont.boldSystemFont(ofSize: size)
    }
}




//View

let keyWindow = (UIApplication.shared.delegate!.window!)!

