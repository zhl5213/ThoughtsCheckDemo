//
//  UIColor + Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/9.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func randomColor()->UIColor {
      return  self.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
    }
    
    
    static func colorWithRGBA(r:UInt8,g:UInt8,b:UInt8,alpha:Float) -> UIColor{
        
        return UIColor.init(red: CGFloat(Float(r)/255.0), green: CGFloat(Float(g)/255.0), blue: CGFloat(Float(b)/255.0), alpha: CGFloat(alpha))
    }
    
    static func colorWithRGB(r:UInt8,g:UInt8,b:UInt8) -> UIColor{
        
        return colorWithRGBA(r: r, g: g, b: b, alpha: 1)
    }
    
    static func colorWithHex(hex : Int) -> UIColor {
        return UIColor.colorWithHex(hex: hex, alpha: 1)
    }
    
    static func colorWithHex(hex : Int , alpha : CGFloat) -> UIColor{
        return UIColor.init(red: CGFloat((hex >> 16) & 0xFF)/255.0 , green: CGFloat((hex >> 8) & 0xFF)/255.0 , blue: CGFloat(hex & 0xFF)/255.0 , alpha: alpha)
    }
    
}
