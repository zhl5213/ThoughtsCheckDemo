//
//  UIImage.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/21.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation

struct CommonImage {
    static let avatarPlaceHolder:UIImage = UIImage.init(named: "avatar")!
    static let rightArrow:UIImage = UIImage.init(named: "arrow_right")!
    static let leftArrow:UIImage = UIImage.init(named: "leftArrow")!
    static let check:UIImage = UIImage.init(named: "me_check")!
    static let videoPlayImage:UIImage = UIImage.init(named:"播放")!
    static let albumPlayImage:UIImage = UIImage.init(named:"播放按钮")!
    static let placeHolder_Square:UIImage = UIImage.init(named: "placeHolder_Square")!
    static let imagePlaceHolder:UIImage = UIImage.init(named: "图片占位图标")!
    static let videoPlaceHolder:UIImage = UIImage.init(named: "视频占位图标")!
    static let placeHolder_9X16:UIImage = UIImage.init(named: "placeHolder_9X16")!
    
    static let wechat:UIImage = UIImage.init(named: "me_wechat")!
    
    
    static func imageWithColor(color:UIColor,size:CGSize = CGSize(width: 1, height: 1)) -> (UIImage?){
        let rect:CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let theImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext() ?? nil
        UIGraphicsEndImageContext()
        return theImage
    }
    
    static func blurryImage(originalImage:UIImage?) -> UIImage? {
        guard let _ = originalImage else {
            return nil
        }
        let context = CIContext(options: nil)
        let inputImage =  CIImage(image: originalImage!)
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(10, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let dx = (outputCIImage.extent.width - (inputImage?.extent.width)!) * 0.25
        let dy = (outputCIImage.extent.height - (inputImage?.extent.height)!) * 0.25
        let frame = outputCIImage.extent.insetBy(dx: dx, dy: dy)
        let cgImage = context.createCGImage(outputCIImage, from: frame)
        //显示生成的模糊图片
        let image = UIImage(cgImage: cgImage!)
        return image
    }
}


