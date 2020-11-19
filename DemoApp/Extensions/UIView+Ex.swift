////
////  UIView+Ex.swift
////  MiniEye
////
////  Created by 朱慧林 on 2019/5/8.
////  Copyright © 2019 MINIEYE. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//fileprivate var viewDescribeKey: UInt8 = 0
//
//struct ViewDescribe {
//
//}
//
//extension UIView {
//
//    func setViewDescribe(string:String) -> () {
//        objc_setAssociatedObject(self, &viewDescribeKey, string, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
//    }
//
//    func viewDescribe() -> String? {
//
//        if let anyStr =  objc_getAssociatedObject(self, &viewDescribeKey) {
//            return (anyStr as! String)
//        } else {
//               if let button = self as? UIButton,let title = button.currentTitle {
//                   return title
//               }else{
//                return nil
//            }
//        }
//    }
//
//    func commonShadowAndCornerRadius(cornerRadius:CGFloat = 1) {
//        setShadow(color: CommonColor.commonShadow,
//                  offset: CGSize(width: 0, height: 3),
//                  radius: 5,
//                  opacity: 1)
//        layer.cornerRadius = cornerRadius
//        clipsToBounds = false
//    }
//
//    func setShadow(color:UIColor = UIColor.black, offset:CGSize = CGSize(width: 0, height: 0), radius:CGFloat = 5.0, opacity:Float = 0.5) {
//        let layer = self.layer
//        layer.shadowColor = color.cgColor
//        layer.shadowOffset = offset; //(0,0)时是四周都有阴影
//        layer.shadowRadius = radius;
//        layer.shadowOpacity = opacity;
//    }
//
//    func clearShaw() {
//        let layer = self.layer
//        layer.shadowColor = UIColor.clear.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: -3); //(0,0)时是四周都有阴影
//        layer.shadowRadius = 0;
//        layer.shadowOpacity = 0;
//    }
//
//
//    @discardableResult
//    func cornerRadius(_ radius:CGFloat) -> UIView {
//        layer.cornerRadius = radius
//        layer.masksToBounds = true
//        return self
//    }
//
//    @discardableResult
//    func borderColor(_ color:UIColor,width:CGFloat) -> UIView {
//        layer.borderColor = color.cgColor
//        layer.borderWidth = width
//        return self
//    }
//
//    static func customMJGifHeader(_ refreshingHandle:@escaping(()->Void)) -> MJRefreshGifHeader? {
//        let header = MJRefreshGifHeader.init {
//            refreshingHandle()
//        }
//        var animation:[UIImage] = []
//        for i in 0..<60 {
//            let name:String = String.init(format: "refresh_animation%03d", i)
//            animation.append(UIImage(named: name)!)
//        }
//
//        header.setImages(animation, duration: 1, for: .idle)
//        header.setImages(animation, duration: 1, for: .pulling)
//        header.setImages(animation, duration: 1, for: .refreshing)
//
//        header.setTitle(MJRefreshHeaderIdleText.localized, for: .idle)
//        header.setTitle(MJRefreshHeaderPullingText.localized, for: .pulling)
//        header.setTitle(MJRefreshHeaderRefreshingText.localized, for: .refreshing)
//
//        header.lastUpdatedTimeLabel?.isHidden = true
//        header.stateLabel?.isHidden = true
//
//        return header
//    }
//
//    static func customMJAutoFooter(_ refreshingHandle:@escaping(()->Void)) -> MJRefreshAutoNormalFooter? {
//        let footer = MJRefreshAutoNormalFooter.init {
//            refreshingHandle()
//        }
//        footer.isRefreshingTitleHidden = true
//        footer.setTitle("", for: .idle)
//        footer.setTitle("", for: .refreshing)
//        footer.setTitle("", for: .noMoreData)
//        return footer
//    }
//
//}
//
//extension UIView {
//
//    func currentScreenShot() -> UIImage {
//        UIGraphicsBeginImageContext(bounds.size)
//        let context:CGContext = UIGraphicsGetCurrentContext()!
//        layer.render(in: context)
//        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        return img
//    }
//
//}
//
