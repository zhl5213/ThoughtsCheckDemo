//
//  PromptHUD.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/27.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation



class CommonPromptHUD: MBProgressHUD,ScreenOrientationRely {
    
    internal var deviceOrientationObserver: NSObjectProtocol?
        /// ovverRide，增加根据屏幕方向旋转的功能
    /// - Parameters:
    ///   - animated: 是否动画显示
    ///   - orientationMatchScreen: 是否根据屏幕的方向来旋转视图
     func show(animated: Bool,orientationMatchScreen:Bool = true) {
        super.show(animated: animated)
        shouldRelyDeviceOrientaion(orientationMatchScreen,for: self.bezelView)
    }
    
    override func hide(animated: Bool) {
        super.hide(animated: animated)
        removeOrientationRely(for: self.bezelView)
    }
    
    class func showInfo(_ info:String?,on view:UIView = keyWindow,hideAfter time:TimeInterval = 3,orientationMatchScreen:Bool = false) -> () {
        
        excuteSyncSafeOnMainThread {
            let hud = CommonPromptHUD.init(view: view)
            hud.label.text = info
            hud.label.numberOfLines = 0
            hud.mode = .text
            hud.common_show(after: time,on:view,orientationMatchScreen:orientationMatchScreen)
        }
    }
    
    
    static func customView(content:String?,imageConvert:ImageConvert)->UIView {
        let backView = BasicView.init()
        backView.backgroundColor = UIColor.clear
        let label = BasicLabel.init()
        label.text = content
        label.numberOfLines = 0
        let imageView = UIImageView.init(image: imageConvert.convertToImage()!)
        backView.addSubview(label)
        backView.addSubview(imageView)
        imageView.sizeToFit()
        imageView.mas_makeConstraints { (make) in
            make?.centerX.top().equalTo()
            make?.left.greaterThanOrEqualTo()(5)
            make?.right.lessThanOrEqualTo()(-5)
        }
        label.sizeToFit()
        label.mas_makeConstraints { (make) in
            make?.centerX.bottom().equalTo()
            make?.top.equalTo()(imageView.mas_bottom)?.offset()(15)
            make?.left.greaterThanOrEqualTo()
            make?.right.lessThanOrEqualTo()
        }
        return backView
    }
    
    
    func common_show(after time:TimeInterval,on view:UIView,orientationMatchScreen:Bool = false) -> () {
        
        excuteSyncSafeOnMainThread {[weak self]in
            guard let self = self else { return }
            self.margin = 30
            self.backgroundView.color = UIColor.init(white: 0, alpha: 0.4)
//            bezelView.color = UIColor.init(white: 1, alpha: 0.95)
            self.bezelView.color = UIColor.clear
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            self.bezelView.insertSubview(blurView, at: 0)
            blurView.mas_makeConstraints { (make) in
                make?.edges.equalTo()(self.bezelView)
            }
            self.bezelView.style = .blur
            self.removeFromSuperViewOnHide = true
            view.addSubview(self)
            view.bringSubviewToFront(self)
            self.show(animated: true,orientationMatchScreen:orientationMatchScreen)
            self.hide(animated: true, afterDelay: time)
        }
    }
    
    

    
    class func showSuccess(_ info:String?,on view:UIView = keyWindow,hideAfter time:TimeInterval = 3,orientationMatchScreen:Bool = true) -> () {
        show(info, image: "保存成功", on: view, hideAfter: time,orientationMatchScreen:orientationMatchScreen)
    }
    
    class func showError(_ info:String?,on view:UIView = keyWindow,hideAfter time:TimeInterval = 3,orientationMatchScreen:Bool = true) -> () {
       show(info, image: "提醒图标", on: view, hideAfter: time,orientationMatchScreen:orientationMatchScreen)
    }
    
    class func show(_ info:String?,image:ImageConvert,on view:UIView = keyWindow,hideAfter time:TimeInterval = 3,orientationMatchScreen:Bool = true) -> () {
        
        excuteSyncSafeOnMainThread {
                   let hud = CommonPromptHUD.init(view: view)
                   hud.mode = .customView
                   hud.customView = customView(content: info, imageConvert:image)
                   hud.common_show(after: time,on:view,orientationMatchScreen: orientationMatchScreen)
        }
    }
    
    
    override var areDefaultMotionEffectsEnabled: Bool {
        get {
            if #available(iOS 12.0, *) {
                return false
            }else {
                return super.areDefaultMotionEffectsEnabled
            }
        }
        set{
            super.areDefaultMotionEffectsEnabled = newValue
        }
    }
    
    
}

