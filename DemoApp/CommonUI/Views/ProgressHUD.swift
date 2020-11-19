//
//  AJTProgressHUD.swift
//  anjet charger
//
//  Created by 朱慧林 on 2018/5/21.
//  Copyright © 2018年 Anjet. All rights reserved.
//

import UIKit



class ProgressHUD: MBProgressHUD,ScreenOrientationRely {
    
    internal var deviceOrientationObserver: NSObjectProtocol?
    var isDeiveOrientationRely:Bool = false {
        didSet {
            shouldRelyDeviceOrientaion(isDeiveOrientationRely, for: self.bezelView)
        }
    }
    
    /// ovverRide，增加根据屏幕方向旋转的功能
    /// - Parameters:
    ///   - animated: 是否动画显示
    ///   - orientationMatchScreen: 是否根据屏幕的方向来旋转视图
     func show(animated: Bool,orientationMatchScreen:Bool = false) {
        super.show(animated: animated)
        isDeiveOrientationRely = orientationMatchScreen
    }
    
    override func hide(animated: Bool) {
        super.hide(animated: animated)
        removeOrientationRely(for: self.bezelView)
    }
    
    /// 显示加载进度
    /// - Parameters:
    ///   - View: 要添加的父视图，默认添加到主window上
    ///   - status: 描述语句，默认为空
    ///   - animated: 是否动画显示
    ///   - needSyn: 是否主线程同步，默认为false
    ///   - orientationMatchScreen: 是否随设备的角度旋转显示的内容，主要指文字
    ///   - detailSetting: 提供hud以设置额外的属性参数等
    class func showLoadingDataHUD(on View:UIView = keyWindow,with status:String = "",animated:Bool,needSyn:Bool = false,orientationMatchScreen:Bool = false,detailSetting: ((_ hud:ProgressHUD)->())? = nil) {
        
        excuteSyncSafeOnMainThread{
            ProgressHUD.hideHUD(on: View, animated: false, after: 0)
            
            let loadDataHUD = ProgressHUD(view: View)
            loadDataHUD.removeFromSuperViewOnHide = true
            View.addSubview(loadDataHUD)
            loadDataHUD.mode = .indeterminate
            loadDataHUD.label.text = status
            loadDataHUD.show(animated: animated,orientationMatchScreen:orientationMatchScreen)
            detailSetting?(loadDataHUD)
        }
        
    }
    
    func changeAfter(_ time:TimeInterval,changeBlock:@escaping (_ progressView:ProgressHUD) -> ()) -> () {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] in
            guard let self = self else {return}
            changeBlock(self)
        }
    }
    
    
    class func showCancelLoadingDataHUD (on View:UIView = keyWindow,with status:String = "",animated:Bool,orientationMatchScreen:Bool = false,cancelCompletion:(()->())?) {
        excuteSyncSafeOnMainThread{
            ProgressHUD.hideHUD(on: View, animated: false, after: 0)
            
            let loadDataHUD = ProgressHUD(view: View)
            loadDataHUD.removeFromSuperViewOnHide = true
            View.addSubview(loadDataHUD)
            loadDataHUD.mode = .indeterminate
            loadDataHUD.label.text = status
            loadDataHUD.button.setTitle("取消".localized, for: .normal)
            loadDataHUD.button.addTarget(loadDataHUD, action: #selector(buttonIsTapped(sender:)), for: UIControl.Event.touchUpInside)
            loadDataHUD.buttonClicked = { (_,_)in
                cancelCompletion.map({ $0() })
            }
            loadDataHUD.show(animated: animated,orientationMatchScreen:orientationMatchScreen)
        }
    }
    
    
    class func showInfo(_ info:String,on view:UIView = keyWindow,orientationMatchScreen:Bool = false,hideAfter time:TimeInterval = 3) -> () {
        
        ProgressHUD.hideHUD(on: view, animated: false, after: 0)
        let hud = ProgressHUD.init(view: view)
        hud.label.text = info
        hud.label.numberOfLines = 0
        //        TODO :label的宽度没有限制，应该设置宽度限制，当字符过多的时候改为换行；
        hud.mode = .text
        hud.bezelView.color = UIColor.init(white: 0.95, alpha: 0.8)
        hud.bezelView.style = .blur
        hud.removeFromSuperViewOnHide = true
        view.addSubview(hud)
        view.bringSubviewToFront(hud)
        hud.show(animated: true,orientationMatchScreen:orientationMatchScreen)
        hud.hide(animated: true, afterDelay: time)
        
    }
    
    //iOS 12.0以上的，iPhone X系列，会出现Main Thread Checker: UI API called on a background thread: -[UIApplication applicationState]
    //    PID: 850, TID: 218915, Thread name: com.apple.CoreMotion.MotionThread, Queue name: com.apple.root.default-qos.overcommit, QoS: 的错误， 解决方法：https://github.com/jdg/MBProgressHUD/issues/552
    override var areDefaultMotionEffectsEnabled: Bool {
        get {
            if  #available(iOS 12.0, *) {
                return false
            }else {
                return super.areDefaultMotionEffectsEnabled
            }
        }
        set{
            super.areDefaultMotionEffectsEnabled = newValue
        }
    }
    
    
    class func HUD(for view:UIView) -> ProgressHUD? {
        if let hud = super.init(for: view) {
            return (hud as! ProgressHUD)
        } else {
            return nil
        }
    }
    
    
    class func showProgess(on view:UIView = keyWindow, _ progess:Float,status:String,animated:Bool,orientationMatchScreen:Bool = false,detailSetting: ((_ hud:ProgressHUD)->())?)  {
        
        excuteSyncSafeOnMainThread {
            
            if let loadDataHUD = ProgressHUD.HUD(for: view) {
                loadDataHUD.mode = .annularDeterminate
                loadDataHUD.progress = progess
                loadDataHUD.label.text = status
                loadDataHUD.label.numberOfLines = 0
                loadDataHUD.isDeiveOrientationRely = orientationMatchScreen
            }else {
                let loadDataHUD = ProgressHUD(view: view)
                loadDataHUD.mode = .annularDeterminate
                loadDataHUD.progress = progess
                loadDataHUD.label.text = status
                loadDataHUD.label.numberOfLines = 0
                view.addSubview(loadDataHUD)
                view.bringSubviewToFront(loadDataHUD)
//                loadDataHUD.button.addTarget(loadDataHUD, action: #selector(buttonIsTapped(sender:)), for: UIControl.Event.touchUpInside)
                //                loadDataHUD.buttonClicked = buttonAction

                loadDataHUD.show(animated: true,orientationMatchScreen:orientationMatchScreen)
                detailSetting.map({$0(loadDataHUD)})
            }
        }
    }
    
    var buttonClicked:ControlClicked?
    
    @objc func buttonIsTapped(sender:UIButton) -> () {
        if let actionBlock = buttonClicked {
            actionBlock(sender,.touchUpOutside)
        }
    }
    
    
    class func  changeStatus(on view:UIView = keyWindow, _ status:String) {
        excuteSyncSafeOnMainThread {
            if let hudView = MBProgressHUD(for: view) {
                hudView.label.text = status
            }else{
                print_Debug(message: "do not have progessHUD on view=\(view)")
            }
        }
    }
    
    
    class  func hideHUD(on view:UIView = keyWindow,animated:Bool,after time:TimeInterval = 0) {
        
        excuteSyncSafeOnMainThread {
            if let hudView = ProgressHUD.HUD(for: view) {
                hudView.removeFromSuperViewOnHide = true
                hudView.hide(animated: animated, afterDelay: time)
            }
//            for subview in view.subviews {
//                if subview.isKind(of: ProgressHUD.self){
//                    subview.removeFromSuperview()
//                }
//            }
        }
    }
    
    
}




