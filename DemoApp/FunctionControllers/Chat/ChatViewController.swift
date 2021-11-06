//
//  ChatViewController.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/20.
//

import UIKit

var swiftGlobalStr:String = "global swift str"

class ChatViewController: UIViewController {
    
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatInfoTableViewCell.self, forCellReuseIdentifier: ChatInfoTableViewCell.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()

    lazy var rightBarButton: UIButton = {
        let bt = UIButton.init(type: .custom)
        bt.setImage(UIImage.init(named: "发布视频"), for: .normal)
        bt.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        return bt
    }()
    
    var loginButtonHeight:CGFloat = 0
    lazy var loginPromptButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "查看全部视频"), for: .normal)
        button.setTitle("Mac 微信已登录，手机通知已关闭", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = CommonColor.viewBG
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 30)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar.init()
        bar.placeholder = "搜索"
        bar.barStyle = .default
        return bar
    }()
    
    var dataSources:[ChatDataSource] = [ChatDataSource]()
    var opIntArray:[Int]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
//        weak var observer:NSObjectProtocol?
//        observer = NotificationCenter.default.addObserver(forName: nil, object: nil, queue: nil) { (noti) in
//            print("\(observer)")
//        }
        
        ChatContentManager.shared.getAllChatContents(){ [weak self] (dataSource) in
            DispatchQueue.main.async {
                self?.dataSources = dataSource
                self?.tableView.reloadData()
            }
        }
    }
    
    
    func configureSubviews() -> () {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
        
        view.addSubview(searchBar)
        view.addSubview(loginPromptButton)
        view.addSubview(tableView)
        
        searchBar.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()
            make?.top.equalTo()(self.mas_topLayoutGuideBottom)
        }
        
        loginPromptButton.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.searchBar.mas_bottom)
            make?.left.right()?.equalTo()
            make?.height.equalTo()(self.loginPromptButton.intrinsicContentSize.height + 20)
        }
        
        tableView.mas_makeConstraints { (make) in
            make?.left.right()
            make?.top.equalTo()(self.loginPromptButton.mas_bottom)
            make?.bottom.equalTo()(self.mas_bottomLayoutGuideTop)
        }
    }
    
    
    @objc func buttonIsTapped(sender:UIButton) -> () {
      print(" button is Tapped")
       getMachTime()
    }
    
    let absoluteStartTime = "machAbsoluteStartTime"
    let continueStartTime = "machContinueStartTime"
    var machAbsoluteTime:UInt64 = 0
    var machContinueTime:UInt64 = 0
    
    func getMachTime() -> () {
        let defaults = UserDefaults.standard

        if defaults.value(forKey: absoluteStartTime) == nil {
            defaults.setValue(mach_absolute_time(), forKey: absoluteStartTime)
            defaults.setValue(mach_continuous_time(), forKey: continueStartTime)
        }else {
            
           let absoluteSeconds = secondsForMach(startTime:defaults.value(forKey: absoluteStartTime) as! UInt64 , endTime: mach_absolute_time())
            let continueSeconds = secondsForMach(startTime: defaults.value(forKey: continueStartTime) as! UInt64, endTime:mach_continuous_time())
            print("absoluteSeconds are \(absoluteSeconds),continueSeconds are \(continueSeconds)")
        }
      
    }
    
    func secondsForMach(startTime:UInt64,endTime:UInt64) -> TimeInterval {
        var info = mach_timebase_info_data_t.init()
        let result = mach_timebase_info(&info)
        print("mach info  result is \(result)")
        
        return 1e-9 * Double(info.numer/info.denom) * Double((endTime - startTime))
    }

}


extension ChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: ChatInfoTableViewCell.reuseID) as! ChatInfoTableViewCell
        cell.dataSource = dataSources[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ChatSessionViewController.init(chatContent:dataSources[indexPath.row] as! PersonChatContent), animated: true)
    }
    
}
