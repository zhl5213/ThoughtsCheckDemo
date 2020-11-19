//
//  CommonAlertController.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/22.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit


class CommonAlertController: UIAlertController {
    
    var timer:Timer?
    var counterValue:TimeInterval = 0
    
    var isOnScreen:Bool = false
    weak var placeHolderController:UIViewController?
    
    
    struct actionInfo {
        var title:String
        var style:UIAlertAction.Style
        var handler:((_ action:UIAlertAction) -> Void)?
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    static func presentActionSheet(in vc:UIViewController,animated:Bool,title:String? = nil,
                                   message:String? = nil,actionInfos:[actionInfo],completion:(() -> Void)? = nil)->(){
        
        let alertController = CommonAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet)
        
        for actionInfo in actionInfos {
            let action = UIAlertAction.init(title: actionInfo.title, style: actionInfo.style, handler: actionInfo.handler)
            alertController.addAction(action)
        }
        
        vc.present(alertController, animated: animated, completion: completion)
    }
    
    @discardableResult
    static func presentAlertController(in vc:UIViewController?,
                                       animated:Bool,
                                       title:String?,
                                       message:String?,
                                       actionInfos:[actionInfo],
                                       completion:(() -> Void)? = nil)->CommonAlertController{
        
        let alertController = CommonAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        for actionInfo in actionInfos {
            let action = UIAlertAction.init(title: actionInfo.title, style: actionInfo.style, handler: actionInfo.handler)
            alertController.addAction(action)
        }
        if var presentedVC = vc {
            while let tPresented = presentedVC.presentedViewController {
                presentedVC = tPresented
            }
            presentedVC.present(alertController, animated: animated, completion: completion)
        }
        return alertController
    }
    
    
    ///  默认的
    @discardableResult
    static func common_presentAlertDefault(in vc:UIViewController,animated:Bool,title:String?,
                                           message:String?,confirmTitle:String,confirmHandler:((_ action:UIAlertAction) -> Void)?,completion:(() -> Void)? = nil)->CommonAlertController {
        
        let cancelActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:.localized_Cancel,style:UIAlertAction.Style.cancel,handler: nil)
        let confirmActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:confirmTitle,style:UIAlertAction.Style.default,handler: confirmHandler)
       return presentAlertController(in: vc, animated: animated, title: title, message: message, actionInfos: [cancelActionInfo,confirmActionInfo], completion: completion)
        
    }
    
    @discardableResult
    static func common_presentAlertSingularConfirm(in vc:UIViewController,animated:Bool,title:String?,
                                                   message:String?,confirmTitle:String,confirmHandler:((_ action:UIAlertAction) -> Void)?,completion:(() -> Void)? = nil)->CommonAlertController {
        
        let confirmActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:confirmTitle,style:UIAlertAction.Style.default,handler: confirmHandler)
       return presentAlertController(in: vc, animated: animated, title: title, message: message, actionInfos: [confirmActionInfo], completion: completion)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed {
            if  timer != nil {
                timer?.invalidate()
                timer = nil
                counterValue = 0
            }
            
            if !isBeingPresented,isOnScreen {
                view.superview?.removeFromSuperview()
            }
            
            if let controller = placeHolderController {
                controller.removeFromParent()
                placeHolderController = nil
            }
        }
    }
}


extension CommonAlertController {
    
    enum counterChangableMessageType {
        case title
        case message
        case action(index:Int)
    }
    
    struct counterInfo {
        
        var startTime:TimeInterval = 0
        var repeatInterval:TimeInterval = 1
        var endTime:TimeInterval = 0
        var infoCreater:(_ countTime:TimeInterval)->String
        var timeoutBlock:()->()
        var messageType:counterChangableMessageType
        var dissAlertAtEnd:Bool = false
        
    }
    
    @discardableResult
    static func common_presentCounterChangeAlert(in vc:UIViewController?,animated:Bool,title:String?,
                                                 message:String?,actionInfos:[actionInfo],changableInfo:counterInfo,completion:(() -> Void)? = nil)->CommonAlertController{
        
        let alertController = CommonAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        
        for actionInfo in actionInfos {
            let action = UIAlertAction.init(title: actionInfo.title, style: actionInfo.style, handler: actionInfo.handler)
            alertController.addAction(action)
        }
        
        
        let timer = Timer.init(timeInterval: changableInfo.repeatInterval, repeats: true, block: {  (timer) in
            
            if alertController.counterValue < changableInfo.endTime {
                
                let messageStr = changableInfo.infoCreater(alertController.counterValue)
                print_Debug(message: "changable  messageStr=\(messageStr)")

                switch changableInfo.messageType {
                case .title:
                    alertController.title = messageStr
                case .message:
                    alertController.message = messageStr
                case .action(let index):
                    //                title is get only，不能修改;
                    //                var trAction = alertController.actions[index]
                    //                trAction.title = changableInfo.infoCreater(counterValue)
                    fatalError("UIAlertController can not set Alaction title,for index=\(index) ")
                }
                
            }else {
                
                timer.invalidate()
                
                changableInfo.timeoutBlock()
                if changableInfo.dissAlertAtEnd {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            alertController.counterValue += 1
            print_Debug(message: "alert controller counterValue=\(alertController.counterValue)")
            
        })
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        timer.fire()
        alertController.timer = timer
        
        if let vc = vc {
            vc.present(alertController, animated: animated, completion: completion)
        }else{
            
        }
        
        return alertController
    }
    
    @discardableResult
    static func common_presentCounterChangeAlertOnScreen(animated:Bool,title:String?,
                                                         message:String?,actionInfos:[actionInfo],changableInfo:counterInfo,completion:(() -> Void)? = nil)->CommonAlertController{
        
        
        let alertController = common_presentCounterChangeAlert(in: nil, animated: animated, title: title, message: message, actionInfos: actionInfos, changableInfo: changableInfo, completion: nil)
        alertController.presentOnScreen(animated: animated)
        
        return alertController
    }
    
    
}


extension CommonAlertController {
    
    
    fileprivate func presentOnScreen(animated:Bool) -> () {
        
        let placeHolderController = UIViewController()
        (keyWindow.rootViewController as! BasicTabBarVC).children[0].addChild(placeHolderController)
        
        var presentedVC = placeHolderController
        while let tPresented = presentedVC.presentedViewController {
            presentedVC = tPresented
        }
        
        presentedVC.present(self, animated: animated) {
            let alertView =  self.view!
            let superView = alertView.superview!
            print_Debug(message: "alertView'fram=\(alertView.frame),alertView's superView'frame=\(superView.frame)")
            superView.removeFromSuperview()
            keyWindow.addSubview(superView)
            keyWindow.bringSubviewToFront(superView)
            alertView.rotateAsCurrentDeviceOrientation()
        }
        
        
        isOnScreen = true
        self.placeHolderController = placeHolderController
        
    }
    
    @discardableResult
    ///  在UIWindow上显示AlertController，这个alertController
    static func common_presentAlertOnScreen(animated:Bool,title:String?,
                                            message:String?,actionInfos:[actionInfo],completion:(() -> Void)? = nil)->CommonAlertController {
        
        
        let alertController = presentAlertController(in: nil, animated: animated, title: title, message: message, actionInfos: actionInfos, completion: completion)
        alertController.presentOnScreen(animated: animated)
        
        return alertController
    }
    
    
    @discardableResult
    static func common_presentAlertDefaultOnScreen(animated:Bool,title:String?,
                                                   message:String?,confirmTitle: String, confirmHandler:((_ action:UIAlertAction) -> Void)?,completion:(() -> Void)? = nil)->CommonAlertController {
        
        let cancelActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:.localized_Cancel,style:UIAlertAction.Style.cancel,handler: nil)
        let confirmActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:confirmTitle,style:UIAlertAction.Style.default,handler: confirmHandler)
        
        return common_presentAlertOnScreen(animated: animated, title: title, message: message, actionInfos: [cancelActionInfo,confirmActionInfo],completion: completion)
    }
    
    @discardableResult
    static func common_presentAlertSingularConfirmOnScreen(animated:Bool,title:String?,
                                                   message:String?,confirmTitle:String,confirmHandler:((_ action:UIAlertAction) -> Void)?,completion:(() -> Void)? = nil)->CommonAlertController {
        let confirmActionInfo:CommonAlertController.actionInfo = CommonAlertController.actionInfo.init(title:confirmTitle,style:UIAlertAction.Style.default,handler: confirmHandler)
       return common_presentAlertOnScreen(animated: animated, title: title, message: message, actionInfos: [confirmActionInfo],completion: completion)
    }
    
}


extension CommonAlertController {
    
      override var shouldAutorotate: Bool {
       return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
}


extension UIView {
    
    func rotateAsCurrentDeviceOrientation() -> () {
//        print_Debug(message: "before rotateAsCurrentDeviceOrientation,transform=\(transform),frame =\(frame)")
        switch UIApplication.shared.statusBarOrientation {
           case .landscapeRight:
                transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
                frame = frame.applying(transform)
            case .landscapeLeft:
                transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi/2)
                frame = frame.applying(transform)
            default:
                break
//                print_Debug(message: "statusBarOrientation not landScape ,orientation=\(UIApplication.shared.statusBarOrientation.rawValue),transform=\(transform),frame =\(frame)")
            }
    }
}
