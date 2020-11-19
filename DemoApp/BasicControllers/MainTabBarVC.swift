//
//  YHMainTabBarVC.swift
//  ttkhj
//
//  Created by nin on 2017/6/27.
//  Copyright © 2017年 yunhang. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        tabBar.backgroundImage = CommonImage.imageWithColor(color:.white)
//        self.tabBar.shadowImage = UIImage(named: "tabbar_shadow")
        delegate = self
        selectedIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        
    /**
     * 设置tabbar
     */
    fileprivate func addChildViewControllers()  {
        
        let chatVC = ChatViewController.init()
        let adressBookVC = AdressBookViewController.init()
        let discoveryVC = DiscoveryViewController.init()
        let myVC = MyViewController.init()
        let tabBarItemTitle:[String] = ["微信","通讯录","发现","我"]
        let imageName = ["tab_home","tab_device","tab_me","tab_me"]
        var tabBarItemImage = [UIImage]()
        var tabBarItemSelectedImages = [UIImage]()
        
        for i in 0..<imageName.count {
            let noseleImage = UIImage.init(named: imageName[i])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            noseleImage?.sd_resizedImage(with: CGSize.init(width: 11, height: 11), scaleMode: .aspectFit)
            var seleImage = noseleImage
            if let trSeleImage =  UIImage.init(named: imageName[i] + "-selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) {
                seleImage = trSeleImage
            }
            
            tabBarItemImage.append(noseleImage!)
            tabBarItemSelectedImages.append(seleImage!)
        }
        
        let vcArr = [chatVC,adressBookVC,discoveryVC,myVC]
        for i in 0..<vcArr.count {
               setChildViewController(vcArr[i],
                                      noselectImage: tabBarItemImage[i],
                                      selectImage: tabBarItemSelectedImages[i],
                                      title: tabBarItemTitle[i])
        }
    }
    
    
    func setChildViewController(_ vc:UIViewController,noselectImage:UIImage,selectImage:UIImage,title:String)  {
        
        let nav = MainNavigationVC(rootViewController : vc)
       
        vc.tabBarItem.image = noselectImage
        vc.tabBarItem.selectedImage = selectImage
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CommonColor.tabHighlightColor], for: UIControl.State.selected)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CommonColor.tabColor], for: UIControl.State.normal)
        vc.title = title
        vc.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -2.5)
       
        self.addChild(nav)
    }
    
}


extension MainTabBarVC {
    
    override var shouldAutorotate: Bool {
        
        if let controllers = viewControllers,controllers.count > selectedIndex {
             let vc = controllers[selectedIndex]
            if let navVC = vc as? UINavigationController {
                return navVC.shouldAutorotate
            }else {
                return vc.shouldAutorotate
            }
        }
        return false
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if let controllers = viewControllers,controllers.count > selectedIndex {
            let vc = controllers[selectedIndex]
            if let navVC = vc as? UINavigationController {
                return navVC.supportedInterfaceOrientations
            }else{
                return vc.supportedInterfaceOrientations
            }
        }
       return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        if let controllers = viewControllers,controllers.count > selectedIndex {
            let vc = controllers[selectedIndex]
            
            if let navVC = vc as? UINavigationController {
                return navVC.preferredInterfaceOrientationForPresentation
            }else{
                return vc.preferredInterfaceOrientationForPresentation
            }
        }
        return UIInterfaceOrientation.portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if  let vc = selectedViewController {
            if let navVC = vc as? UINavigationController {
                return navVC.preferredStatusBarStyle
            }else{
                return vc.preferredStatusBarStyle
            }
        }
        return UIStatusBarStyle.default
    }
    
    override var prefersStatusBarHidden: Bool {
        
        if  let vc = selectedViewController {
            if let navVC = vc as? UINavigationController {
                return navVC.prefersStatusBarHidden
            }else{
                return vc.prefersStatusBarHidden
            }
        }
        return false
    }
}


extension UITabBar {
    func showBadgeOnItem(index:Int, count:Int = 0) {
        removeBadgeOnItem(index: index)
        let bview = UIView.init()
        bview.tag = 888+index
        bview.layer.cornerRadius = 5
        bview.clipsToBounds = true
        bview.backgroundColor = CommonColor.redColor
        let tabFrame = self.frame
        let countOfItem =  items?.count ?? 3
        let percentX = (Float(index)+0.6) / Float(countOfItem)
        let x = CGFloat(ceilf(percentX*Float(tabFrame.width)))
        let y = CGFloat(ceilf(0.1*Float(tabFrame.height)))
        bview.frame = CGRect(x: x, y: y, width: 10, height: 10)
        
        let cLabel = UILabel.init()
        if count != 0 {
            cLabel.text = "\(count)"
        }
        cLabel.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        cLabel.font = UIFont.systemFont(ofSize: 10)
        cLabel.textColor = UIColor.white
        cLabel.textAlignment = .center
        bview.addSubview(cLabel)

        addSubview(bview)
        bringSubviewToFront(bview)
    }
    //隐藏红点
    func hideBadgeOnItem(index:Int) {
        removeBadgeOnItem(index: index)
    }
    //移除控件
    func removeBadgeOnItem(index:Int) {
        for subView:UIView in subviews {
            if subView.tag == 888+index {
                subView.removeFromSuperview()
            }
        }
    }
}
