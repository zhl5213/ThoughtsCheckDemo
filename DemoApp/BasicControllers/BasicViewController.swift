

import UIKit
import NetworkExtension
import Alamofire

class BasicViewController: UIViewController,ViewContainer {
    
    var notiObservers = [NSObjectProtocol]()
    var viewDidDisappeared:Bool = false
    
    private var foregroundObservers:[NSObjectProtocol] =  [NSObjectProtocol]()
    ///  设置true来开启监听设备是否返回、退出工作界面，监听会在控制器销毁时自动销毁。
    var monitorIfEnterForeground = false {
        didSet{
            
            if monitorIfEnterForeground {
                
                if foregroundObservers.count == 0 {
                    let enterForObserver =  NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: UIApplication.shared, queue: nil) { [weak self](noti) in
                        guard let self = self else { return }
                        print_Debug(message: "in \(self) willEnterForegroundNotification")
                        self.appWillEnterForground()
                    }
                    
                    let becomeActiveObserver =  NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: UIApplication.shared, queue: nil) { [weak self](noti) in
                        guard let self = self else { return }
                        print_Debug(message: "in \(self) didBecomeActiveNotification")
                        self.appDidBecomeActive()
                    }
                    
                    let resignActiveObserver =  NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: UIApplication.shared, queue: nil) { [weak self](noti) in
                        guard let self = self else { return }
                        print_Debug(message: "in \(self) willResignActiveNotification")
                        self.appWillResignActive()
                    }
                    print_Debug(message: " \(self) start monitor enter foreground ")
                    foregroundObservers.append(contentsOf: [enterForObserver,becomeActiveObserver,resignActiveObserver])
                }
                
            }else{
                for observer in foregroundObservers {
                    NotificationCenter.default.removeObserver(observer)
                }
                foregroundObservers.removeAll()
            }
        }
    }
    
/// 能够接受的wifi自动变化时间上限
    let wifiAutoChangeTime:TimeInterval = 5
/// 监听设备连接状态变化结束；
    var connectStatusFinished = false
///
    var finalConnectStatus:ConnectStatus = ConnectStatus.init(connetedToDevice: false, needAuthorization: nil, error: nil, wifiName: nil)
    var isAlreadyInDevice:Bool = false
//    var stopConnectDevice:Bool = false
    var connectStatusObserver:NSObjectProtocol?
    var appIsActive:Bool = false
    

///  正在进入设备的时候，如果present控制器，那么push会失效；所以在本属性是true的时候，不允许present界面；
    var isEnteringDevice = false

    override func loadView() {
        super.loadView()
        view = BasicView.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CommonColor.viewBG
        //        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        //        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 50

        configureSubviews()
        self.navigationController?.navigationBar.setBackgroundImage(CommonImage.imageWithColor(color: .clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidDisappeared = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappeared = true
    }
    
    func appWillEnterForground() -> () {
        appIsActive = true
    }
    
/// override need call super
    func appDidBecomeActive() -> () {
        appIsActive = true
    }
    
    /// override need call super
    func appWillResignActive() -> () {
        appIsActive = false
    }

    
    func setLeftBarButton() {
        if let navController = self.navigationController {
            if navController.children.count > 1 {
                
                let button = UIButton.init(type: .custom)
                button.setImage(CommonImage.leftArrow, for: .normal)
                button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -9, bottom: 0, right: 0)
                button.contentHorizontalAlignment = .left
                button.frame = CGRect.init(x: 0, y: 0, width: 55, height: NavigationBarH)
                button.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
            }
        }
    }
    
    @objc func back(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureSubviews() {
        
    }
    
    
    deinit{
        for observer in notiObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        notiObservers.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    func toLoginContollerIfNeeded() -> Bool {
        if !UserAccountManager.shared.isLogin() {
            let controller = AccountUsageViewController.init(vcType: .loginUseSM)
            self.navigationController?.pushViewController(controller, animated: true)
            return false
        }
        return true
    }
       
}



@objc protocol ViewContainer {
    @objc optional func configureSubviews()
}


//MARK: - ZFPlayer -
extension BasicViewController {
    
    override var shouldAutorotate: Bool {
        if self.presentingViewController != nil {
            return false
        }
        return super.shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if self.presentingViewController != nil {
            return .portrait
        }
        return super.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if self.presentingViewController != nil {
            return .portrait
        }
        return super.preferredInterfaceOrientationForPresentation
    }
}




