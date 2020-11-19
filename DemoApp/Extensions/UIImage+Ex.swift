//
//  UIImage+Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/8.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation
import UIKit

//MARK:- create custom Image  -
extension UIImage {
    
    static func createRandomColorImage(imageSize:CGSize) -> UIImage{
        
        let randomColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
        return createImageWith(color: randomColor, size:imageSize)
    }
    
    static func createImageWith(color:UIColor,size:CGSize)->UIImage {
        let r = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(r.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(r)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    static func createCircleImageWith(color:UIColor,radius:CGFloat,opaque:Bool = true)->UIImage {
        let circle = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: radius * 2, height: radius * 2), cornerRadius: radius)
        
        UIGraphicsBeginImageContextWithOptions(circle.bounds.size, false, UIScreen.main.scale)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.addPath(circle.cgPath)
        context.setFillColor(color.cgColor)
        context.fillPath()
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
        
}

//MARK:- change Image size  -
extension UIImage {
    
    func transofromSize(to targetSize:CGSize,opaque:Bool = true) -> UIImage {
        
        let drawRect = CGRect.init(origin: CGPoint.zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(drawRect.size, opaque, UIScreen.main.scale)
        self.draw(in: drawRect)
        let thumbNailImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return thumbNailImage
    }
    
}

//MARK:- ImageConvert  -

protocol ImageConvert {
    
    func isUIImageDirectConvertable() -> Bool
    func convertToImage() -> UIImage?
    
}

extension UIImage:ImageConvert {
    
    func isUIImageDirectConvertable() -> Bool {
        return true
    }
    
    func convertToImage() -> UIImage? {
        return self
    }
    
}


extension String:ImageConvert {
    
    func isUIImageDirectConvertable() -> Bool {
        return UIImage.init(named: self) != nil
    }
    
    func convertToImage() -> UIImage? {
        return UIImage.init(named: self)
    }
    
}
