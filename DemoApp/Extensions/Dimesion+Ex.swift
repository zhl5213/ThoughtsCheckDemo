//
//  TimeInterval+Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/6/18.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation


extension TimeInterval {
    
    enum style:String {
        case mm_ss = "mm:ss"
        case hh_mm_ss = "hh:mm:ss"
        case dd_hh_mm_ss = "dd:hh:mm:ss"
    }
    
    func changeToTimeString(_ timeStyle:style) -> String? {
        
        guard self >= 0 else {
            return nil
        }
        let intSelf = Int(self)
        
        let second = intSelf % 60
        let minute = (intSelf / 60) % 60
        let hour = (intSelf / 3600) % 24
        let day = (intSelf / 3600) / 24
        
        switch timeStyle {
        case .mm_ss:
            return "\(minute.toStr(totalDigit: 2)):\(second.toStr(totalDigit: 2))"
        case .hh_mm_ss:
            return "\(hour.toStr(totalDigit: 2)):\(minute.toStr(totalDigit: 2)):\(second.toStr(totalDigit: 2))"
        case .dd_hh_mm_ss:
            return "\(day.toStr(totalDigit: 2)):\(hour.toStr(totalDigit: 2)):\(minute.toStr(totalDigit: 2)):\(second.toStr(totalDigit: 2))"
        }
    }
    
}

extension Int {
    
    func toStr(totalDigit:Int) -> String {
        return String.init(format: "%.\(totalDigit)d", self)
    }
    
    func toKBOrMB() -> (value:CGFloat,isMB:Bool) {
        return Double(self).toKBOrMB()
    }
}

extension Int64 {
    
    func toMB() -> CGFloat {
        return CGFloat(self/(1024*1024))
    }
    
    func toKBOrMB() -> (value:CGFloat,isMB:Bool) {
       return Double(self).toKBOrMB()
    }
}

extension CGFloat {
    
    
    /// 将数值截取成小数点后places位
    /// - Parameter places: 小数点后保留位数
    func roundTo(places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    
    /// Rounds the double to decimal places value
    
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
    func toKBOrMB() -> (value:CGFloat,isMB:Bool) {
        let MB = self/(1024*1024)
        if MB > 1 {
            return (CGFloat(MB.roundTo(places: 2)),true)
        }
        
        let KB = self/1024
        return (CGFloat(KB.roundTo(places: 2)),false)
    }
    
    func toPercentage() -> String {
        return String.init(format: "%.0f%%", roundTo(places: 2) * 100)
    }
    
}

