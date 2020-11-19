//
//  YHMainNavigationVC.swift
//  ttkhj
//
//  Created by nin on 2017/6/27.
//  Copyright © 2017年 yunhang. All rights reserved.
//

import UIKit


class MainNavigationVC: UINavigationController {
            
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.delegate = self
        self.configNavigationBar()
//        self.navigationController?.navigationBar.delegate = self
    }
    
    func configNavigationBar() {
//        UINavigationBar.appearance().setBackgroundImage(CommonImage.imageWithColor(color: CommonColor.viewBG), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.black
        navBar.backIndicatorImage = CommonImage.leftArrow
        navBar.backIndicatorTransitionMaskImage = CommonImage.leftArrow
        navBar.isTranslucent = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count == 1 {
            // 隐藏tabbar
            viewController.hidesBottomBarWhenPushed = true
        }
        setBackButton(for:viewController)

        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if viewControllers.count >= 2 {
            // 隐藏tabbar
            viewControllers[1].hidesBottomBarWhenPushed = true
        }
        
        for viewController in viewControllers {
            setBackButton(for: viewController)
        }

        super.setViewControllers(viewControllers, animated: animated)
    }
    
    func setBackButton(for controller:UIViewController) -> () {

        let backButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        controller.navigationItem.backBarButtonItem = backButtonItem
    }
    
//    所有navigationController push 出来VC，都统一添加leftBarButtonItem，设置方法为back回退
    @objc private func back(_ sender : UIButton){
         let _ = popViewController(animated: true)
    }
}

extension MainNavigationVC:UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        分步骤跳转：pop视图的时候，如果直接使用tabBarController?.selectedIndex，会导致hidesBottomWhenPushed隐藏的tabbar出BUG，因此，需要过渡跳转。
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    
}


//extension BasicNavigationVC {
//    
//    override var shouldAutorotate: Bool {
//        if self.topViewController is DeviceVideosPlayViewController || self.topViewController is DeviceAdjustViewController {
//            return self.topViewController!.shouldAutorotate
//        }
//        return false
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if self.topViewController is DeviceVideosPlayViewController || self.topViewController is DeviceAdjustViewController {
//            return self.topViewController!.supportedInterfaceOrientations
//        }
//        return UIInterfaceOrientationMask.portrait
//    }
//    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        if self.topViewController is DeviceVideosPlayViewController || self.topViewController is DeviceAdjustViewController {
//            return self.topViewController!.preferredInterfaceOrientationForPresentation
//        }
//        return UIInterfaceOrientation.portrait
//        
//    }
// 
//    override var childForStatusBarStyle: UIViewController? {
//        return topViewController
//    }
//    
//    override var childForStatusBarHidden: UIViewController? {
//        return topViewController
//    }
//    
//    
//}
