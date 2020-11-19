//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import UIKit


//  BasicButton.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/8.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

enum SomeE:UInt,CaseIterable {
    case zero
    case first
    case second
    
    func descrip() -> String {
        var descrip:String
        switch rawValue {
        case 0:
            descrip = "not restricted"
        case 1:
            descrip = "restricted"
        default:
            descrip = "unknown"
        }
        return descrip
    }
}

let allCases = SomeE.allCases
print("allcases is \(allCases.map({$0.descrip()}))")


class BasicButton: UIButton {

       enum CContentAlignment {
           case imageTopTitleBottom
           case imageBottomTitleTop
           case imageLeftTitleRight
           case imageRightTitleLeft
       }

    var cContentAlignment:CContentAlignment = .imageLeftTitleRight
    var highlightSelectedStateRelayOnCurrent:Bool = false
    override var isSelected: Bool {
        didSet {
            if highlightSelectedStateRelayOnCurrent {
                setImage(currentImage, for: UIControl.State.init(rawValue: 5))
                setTitle(currentTitle, for: UIControl.State.init(rawValue: 5))
            }
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

     override var intrinsicContentSize: CGSize {
            if cContentAlignment == .imageLeftTitleRight || cContentAlignment == .imageRightTitleLeft {
                return super.intrinsicContentSize
            }else {
                let imageSize = currentImage?.size ?? CGSize.zero
                let titleSize = titleLabel?.intrinsicContentSize ?? CGSize.zero
    //            print_Debug(message: "imageSize is \(imageSize),titleSize is \(titleSize),finalSize is \(CGSize.init(width: max(titleSize.width, imageSize.width), height: titleSize.height + imageSize.height))")
                return CGSize.init(width: max(titleSize.width, imageSize.width), height: titleSize.height + imageSize.height)
            }
        }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return computeRect(for: contentRect, isImage: false)
    }
    
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return computeRect(for: contentRect, isImage: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if  (cContentAlignment == CContentAlignment.imageBottomTitleTop) || (cContentAlignment == CContentAlignment.imageTopTitleBottom),titleLabel != nil {
            titleLabel?.textAlignment = .center
        }
    }
    
    func computeRect(for contentRect:CGRect,isImage:Bool) -> CGRect {
        
        if contentRect == CGRect.zero {
            return CGRect.zero
        }
        
        let oTitleRect = super.titleRect(forContentRect: contentRect)
        let oImageRect = super.imageRect(forContentRect: contentRect)
        var x:CGFloat = isImage ? oImageRect.minX : oTitleRect.minX
        var y:CGFloat = isImage ? oImageRect.minY : oTitleRect.minY
        var width:CGFloat = isImage ? oImageRect.width : oTitleRect.width
        var height:CGFloat = isImage ? oImageRect.height : oTitleRect.height
        var verticalAlignContentHeight = oImageRect.height + oTitleRect.height
        
        if  (cContentAlignment == CContentAlignment.imageBottomTitleTop) || (cContentAlignment == CContentAlignment.imageTopTitleBottom) {
            
            if isImage {
                width = min(currentImage?.size.width ?? 0, contentRect.size.width)
            }else {
                var size = CGSize.zero
                size = sizeThatFits(contentRect.size)
                width = min(size.width, contentRect.width)
            }
            
            if verticalAlignContentHeight > contentRect.height,verticalAlignContentHeight > 0, contentRect.height > 0 {
                verticalAlignContentHeight = contentRect.height
                let imageRatio = oImageRect.height / verticalAlignContentHeight
                height = isImage ?  (imageRatio * verticalAlignContentHeight) : ((1-imageRatio) * verticalAlignContentHeight)
            }
        }
        
        let verticalAdding = isImage ? (imageEdgeInsets.top - imageEdgeInsets.bottom) :  (titleEdgeInsets.top - titleEdgeInsets.bottom)
        let horizinalAdding = isImage ? (imageEdgeInsets.left - imageEdgeInsets.right) :  (titleEdgeInsets.left - titleEdgeInsets.right)

        switch cContentAlignment {
            
        case .imageBottomTitleTop:
           
            x = bounds.width/2 - width/2 + horizinalAdding
            y = bounds.height/2  + (isImage ? (verticalAlignContentHeight/2 - oImageRect.height) : -verticalAlignContentHeight/2) + verticalAdding
//            print_Debug(message: "title Rect called for imageBottomTitleTop,x =\(x),y=\(y),currentTitle=\(currentTitle),isimage =\(isImage),width=\(width),height=\(height)")
        case .imageTopTitleBottom:
            x = bounds.width/2 - width/2 + horizinalAdding
            y = bounds.height/2 + (isImage ? -verticalAlignContentHeight/2 : (verticalAlignContentHeight/2 - oTitleRect.height)) + verticalAdding
//            print_Debug(message: "title Rect called for imageTopTitleBottom,x =\(x),y=\(y),currentTitle=\(currentTitle),isimage =\(isImage),width=\(width),height=\(height)")
        case .imageRightTitleLeft:
            x += isImage ? (oTitleRect.width) :( -oImageRect.width)
//            print_Debug(message: "title Rect called for imageRightTitleLeft,x =\(x),y=\(y),currentTitle=\(currentTitle),isimage =\(isImage),width=\(width),height=\(height)")
        case .imageLeftTitleRight:
            break
        }
        
        return CGRect.init(x: x, y: y, width: width, height: height)
    }

}

extension UIImage {
    
    func redraw(at renderSize:CGSize,backgroundColor:UIColor? = nil)->UIImage? {
        UIGraphicsBeginImageContextWithOptions(renderSize, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let drawCenter = CGPoint.init(x: (renderSize.width - size.width)/2, y: (renderSize.height - size.height)/2)
        let imageRect = CGRect.init(origin: drawCenter, size: size)
        if let trbackgroundColor = backgroundColor {
            context?.addPath( UIBezierPath.init(rect: CGRect.init(origin: CGPoint.zero, size: renderSize)).cgPath)
            context?.setFillColor(trbackgroundColor.cgColor)
            context?.fillPath(using: .evenOdd)
        }
        UIGraphicsPushContext(context!)
        draw(in: imageRect)
        UIGraphicsPopContext()
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage
    }
    
}

extension UIImage {
    
    var aspectRatio:CGFloat {
        return size.width / size.height
    }
    
    var sotreSize:String? {
        var data = pngData()
        if data == nil {
            data = jpegData(compressionQuality: 0.5)
        }
        guard let trData = data else {
            return nil
        }
        var dataLength = Double(trData.count)
        let typeArr = ["bytes","KB","MB","GB","TB","PB", "EB","ZB","YB"]
        var typeIndex = 0
        while dataLength > 1024 {
            dataLength /= 1024.0
            typeIndex += 1
        }
        return String.init(format: "%.3f", dataLength) + "\(typeArr[typeIndex])"
    }
    
}


let image = UIImage.init(named: "Browse_icon_picture loading")
//    ?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0), resizingMode: .stretch)
print("image's store size is \(image?.sotreSize)")

let bt = BasicButton.init(type: .custom)
bt.cContentAlignment = .imageTopTitleBottom
bt.setImage(UIImage.init(named: "Browse_icon_picture loading"), for: .normal)
bt.setTitle("测试按钮大小", for: .normal)
bt.setTitleColor(UIColor.blue, for: .normal)
bt.frame = CGRect.init(x: 20, y: 50, width: 200, height: 100)


let renderSize = CGSize.init(width: 40, height: 40)

let layer = CALayer.init()
layer.contents = image?.cgImage
layer.contentsGravity = .center
layer.contentsScale = UIScreen.main.scale
layer.frame = CGRect.init(origin: CGPoint.zero, size: renderSize)
layer.display()

//UIGraphicsBeginImageContextWithOptions(renderSize, true, UIScreen.main.scale)
//let context = UIGraphicsGetCurrentContext()
//
////layer.draw(in: context!)
//let imageOriginSize = image!.size
//let drawCenter = CGPoint.init(x: (renderSize.width - imageOriginSize.width)/2, y: (renderSize.height - imageOriginSize.height)/2)
//let imageRect = CGRect.init(origin: drawCenter, size: imageOriginSize)
//context?.addPath( UIBezierPath.init(rect: CGRect.init(origin: CGPoint.zero, size: renderSize)).cgPath)
//context?.setFillColor(UIColor.red.cgColor)
//context?.fillPath(using: .evenOdd)
////context?.draw((image?.cgImage)!, in:imageRect)
//UIGraphicsPushContext(context!)
//image?.draw(in: imageRect)
//UIGraphicsPopContext()
////context?.translateBy(x: 0, y: -renderSize.height)
////context?.scaleBy(x: 1, y: -1)
//let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//UIGraphicsEndImageContext()

//print("imageOriginSize is \(imageOriginSize),new imageRect is \(imageRect),")


let imageV = UIImageView.init()
//imageV.layer.addSublayer(layer)
imageV.image = image?.redraw(at: CGSize.init(width: 10, height: 9),backgroundColor: nil)
imageV.backgroundColor = UIColor.black
imageV.contentMode = .center
imageV.frame = CGRect.init(x: 20, y: 50, width: 200, height: 100)
//imageV.center = CGPoint.init(x: 40, y: 50)



PlaygroundPage.current.liveView = imageV


//: [Next](@next)
