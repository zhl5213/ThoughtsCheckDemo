//
//  UIDevice+Ex.swift
//  MiniEye
//
//  Created by user_ on 2019/8/14.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation

public enum Model : String {
    case iPod1     = "iPod 1",
    iPod2          = "iPod 2",
    iPod3          = "iPod 3",
    iPod4          = "iPod 4",
    iPod5          = "iPod 5",
    iPod6          = "iPod 6",
    iPod7          = "iPod 7",

    iPad2          = "iPad 2",
    iPad3          = "iPad 3",
    iPad4          = "iPad 4",
    iPad5          = "iPad 5",
    iPad6          = "iPad 6",

    iPadMini1      = "iPad Mini 1",
    iPadMini2      = "iPad Mini 2",
    iPadMini3      = "iPad Mini 3",
    iPadMini4      = "iPad Mini 4",
    iPadMini5      = "iPad Mini 5",

    iPadAir       = "iPad Air",
    iPadAir2       = "iPad Air 2",
    iPadAir3       = "iPad Air 3",

    iPadPro9       = "iPad Pro(9.7)",
    iPadPro_1        = "iPad Pro(12.9)",
    iPadPro_2        = "iPad Pro(12.9) 2Gen",
    iPadPro_3        = "iPad Pro(12.9) 3Gen",
    iPadPro11        = "iPad Pro(11)",
    iPadPro10        = "iPad Pro(10.5)",
    
    iPadPro        = "iPad Pro",
    
    iPhone3G        = "iPhone 3G",
    iPhone3GS        = "iPhone 3GS",
    iPhone4       = "iPhone 4",
    iPhone4S       = "iPhone 4S",
    iPhone5        = "iPhone 5",
    iPhone5S       = "iPhone 5S",
    iPhone5C       = "iPhone 5C",
    iPhone6        = "iPhone 6",
    iPhone6plus    = "iPhone 6 Plus",
    iPhone6S       = "iPhone 6S",
    iPhone6Splus   = "iPhone 6S Plus",
    iPhoneSE       = "iPhone SE",
    iPhone7        = "iPhone 7",
    iPhone7plus    = "iPhone 7 Plus",
    iPhone8        = "iPhone 8",
    iPhone8Plus    = "iPhone 8 Plus",
    iPhoneX        = "iPhone X",
    iPhoneXR       = "iPhone XR",
    iPhoneXS       = "iPhone XS",
    iPhoneXSMax    = "iPhone XS Max",
    
    iPhone11       = "iPhone 11",
    iPhone11Pro       = "iPhone 11 Pro",
    iPhone11ProMax    = "iPhone 11 Pro Max",

        
    AppleTV        = "Apple TV",
    
    iPad           =  "iPad",
    iPod           = "iPod",
    simulator      = "simulator",
    iPhone         = "iPhone",
    unrecognized   = "unrecognized"
    
}

public extension UIDevice {
    
    var modelName: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        let modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad7,5" : .iPad6,
            "iPad7,6" : .iPad6,
            "iPad11,3"   : .iPadAir3,
            "iPad11,4"   : .iPadAir3,

            "iPad6,4" : .iPadPro9,
            "iPad6,3" : .iPadPro9,
            "iPad6,7" : .iPadPro_1,
            "iPad6,8" : .iPadPro_1,
            "iPad7,1" : .iPadPro_2,
            "iPad7,2" : .iPadPro_2,
            "iPad7,3" : .iPadPro10,
            "iPad7,4" : .iPadPro10,
            
            "iPad8,1" : .iPadPro11,
            "iPad8,2" : .iPadPro11,
            "iPad8,3" : .iPadPro11,
            "iPad8,4" : .iPadPro11,

            
            "iPad8,5" : .iPadPro_3,
            "iPad8,6" : .iPadPro_3,
            "iPad8,7" : .iPadPro_3,
            "iPad8,8" : .iPadPro_3,

            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"   : .iPadMini5,
            "iPad11,2"   : .iPadMini5,

            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,8" : .iPhoneXR,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,1" : .iPhone11
        ]
        
        if let model = modelMap[identifier] {
            return model
        }
        if identifier.hasPrefix("iPad") {
            return Model.iPad
        }
        if identifier.hasPrefix("iPod") {
            return Model.iPod
        }
        if identifier.hasPrefix("iPhone") {
            return Model.iPhone
        }
        return Model.unrecognized
    }
}

