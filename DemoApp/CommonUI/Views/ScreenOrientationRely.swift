//
//  CommonHUD.swift
//  
//
//  Created by 朱慧林 on 2020/6/28.
//

import UIKit

extension UIView {
    
    func changeOrientationToMatchScreen() -> () {
        
        let deviceOrientation = UIDevice.current.orientation
        if deviceOrientation.isValidInterfaceOrientation {
            var targetTransform = CGAffineTransform.identity
            
            switch deviceOrientation {
            case .landscapeRight:
                targetTransform = CGAffineTransform.init(rotationAngle: -CGFloat.pi/2)
//                print_Debug(message: "view changeOrientationToMatchScreen,deviceOrientation=\(deviceOrientation.rawValue),transform to - pi/2,frame=\(frame)")
            case .landscapeLeft:
                targetTransform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
//                print_Debug(message: "view changeOrientationToMatchScreen,deviceOrientation=\(deviceOrientation.rawValue),transform to pi/2,frame=\(frame)")
            case .portrait:
                targetTransform = .identity
//                print_Debug(message: "view changeOrientationToMatchScreen,deviceOrientation=\(deviceOrientation.rawValue),transform to identity,frame=\(frame)")
            default:
                print_Debug(message: "device not landScape ,orientation=\(deviceOrientation.rawValue)")
            }
            if transform != targetTransform {
                transform = targetTransform
            }
        }
    }
    
}


protocol ScreenOrientationRely:UIView {
    var deviceOrientationObserver:NSObjectProtocol? {set get}
    func shouldRelyDeviceOrientaion(_ isRely:Bool,for subview:UIView) -> ()
    func removeOrientationRely(for view:UIView) -> ()
}
    
extension ScreenOrientationRely {
    
    func shouldRelyDeviceOrientaion(_ isRely:Bool,for subview:UIView) {
        if isRely {
            subview.changeOrientationToMatchScreen()
            if UIDevice.current.isGeneratingDeviceOrientationNotifications == false {
                UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            }
            if deviceOrientationObserver == nil {
                deviceOrientationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: { [weak self] (noti) in
//                    print_Debug(message: "ScreenOrientationRely obrientation changed,self.isHidden=\(self?.isHidden),self.superview=\(self?.superview),self.frame=\(self?.frame)")
                    guard let self = self,self.isHidden == false,self.superview != nil else { return }
                    subview.changeOrientationToMatchScreen()
                })
            }
        }
    }
    
    func removeOrientationRely(for view:UIView) {
        if let observer = deviceOrientationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

