//
//  AdressBookViewController.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/20.
//

import UIKit
import Alamofire
import Network

class AdressBookViewController: UIViewController {
    
    var mapTable:NSMapTable = NSMapTable<AnyObject,AnyObject>.init(keyOptions: .copyIn, valueOptions: .weakMemory)
    var startTimes:[URL:CFAbsoluteTime] = [:]
    
    lazy var speedLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 60, width: ScreenW, height: 100))
        label.textAlignment = .center
        label.textColor = UIColor.blue
        return label
    }()
    
    let reuseCellId = "reuseCellId"
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.init(x: 0, y: 60, width: ScreenW, height: ScreenH - 100))
        view.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellId)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var downlodbutton: UIButton = {
        let bt = UIButton.init(type: .custom)
        bt.setTitle("重新下载", for: .normal)
        bt.addTarget(self, action: #selector(tryDownloadParall), for: .touchUpInside)
        bt.setTitleColor(UIColor.green, for: .normal)
        return bt
    }()
    
    var dataSource:[(fileName:String,speed:String)] = []
    let fileInfo:[(name:String,urlStr:String)] = [(name:"first","https://dl.softmgr.qq.com/original/im/QQ9.5.1.27888.exe"),
                                                  /*(name: "second","https://dldir1.qq.com/weixin/mac/WeChatMac.dmg"),
                                                  (name: "third", "https://sta-op.douyucdn.cn/dy-app-pkg/douyu_client_123_0v1_3_7.dmg"),
                                                  (name: "four", "https://dl.softmgr.qq.com/original/Office/WeCom_3.1.18.6007_100004.exe"),
                                                  (name: "five", "https://y.qq.com/#:~:text=%E5%AE%A2%E6%88%B7%E7%AB%AF-,%E4%B8%8B%E8%BD%BD"),
                                                  (name: "six", "https://u.163.com/macds?device=desktop&device_id=4da2b101-82ae-483a-83f3-9e98ca9106ef&os=Mac%20OS&os_version=10.15.7&product=mailmac&resolution=1440x900&uuid=2e506c98f31b479b45206dd6b5099dd3"),
                                                  (name: "seven", "https://u.163.com/pcds?device=desktop&device_id=4da2b101-82ae-483a-83f3-9e98ca9106ef&os=Mac%20OS&os_version=10.15.7&product=mailmac&resolution=1440x900&uuid=2e506c98f31b479b45206dd6b5099dd3"),
                                                  (name: "eight", "https://nie.v.netease.com/nie/2021/0809/8e75f9002ceab257d975fee07182c66c.mp4")*/
                                                  
                                                  
    ]
    
    var labels:[String:UILabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(tableView)
//        dataSource = fileInfo.map({ return ( $0.name,"0") })
//        tableView.reloadData()
      
        var index = 0
        var lastLabel:UILabel = UILabel.init()
        fileInfo.forEach { (name,urlStr) in
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 100 + index * 50, width: Int(ScreenW), height: 50))
            label.textAlignment = .center
            label.textColor = UIColor.blue
            label.text = "\(name),speed:0"
            labels[name] = label
            view.addSubview(label)
            lastLabel = label
            index += 1
        }
        
        view.addSubview(downlodbutton)
        downlodbutton.mas_makeConstraints { (make) in
            make?.centerX.equalTo()
            make?.height.equalTo()(30)
            make?.top.equalTo()(lastLabel.mas_bottom)?.offset()(20)
        }
        
    }
    
    
    @objc func tryDownloadParall() -> () {
        for file in fileInfo {
            downloadFileWith(name: file.name, file.urlStr)
        }
    }

    func downloadFileWith(name:String,_ url:String) -> () {
        let documentUrlPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileUrl = URL.init(fileURLWithPath: documentUrlPath.appending("/\(name).dmg"))
        startTimes[fileUrl] = CFAbsoluteTimeGetCurrent()
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
           try? FileManager.default.removeItem(atPath: fileUrl.path)
            print("file exist already,remove it first\n")
        }
        
        let fileDestination:DownloadRequest.DownloadFileDestination = { (tempUrl,response) in
            return (fileUrl,.createIntermediateDirectories)
        }
        print("document url path is \(documentUrlPath),file url is \(fileUrl),will download \(url) \n")
        Alamofire.download(URL.init(string: url)!, to: fileDestination).downloadProgress { (progress) in
            let downloadTime = (CFAbsoluteTimeGetCurrent() - self.startTimes[fileUrl]!)
            let  averageSpeed = Double(progress.completedUnitCount) / (downloadTime) / 1024
//            if  let infoIndex = self.dataSource.firstIndex(where: { $0.fileName == name }) {
//                let info = self.dataSource[infoIndex]
//                self.dataSource[infoIndex] = (info.fileName,"\(averageSpeed) k/s")
//                self.tableView.reloadRows(at: [IndexPath(row: Int(infoIndex), section: 0)], with: .automatic)
//            }
            if let label = self.labels[name] {
                label.text = "\(name),speed:\(String.init(format: "%.1f", averageSpeed)) k/s"
            }
            print("\(name) file,  download progress for \(progress.fractionCompleted) after \(downloadTime) seconds ,averageSpeed is \(averageSpeed) k/s \n")
        }
    }

}

extension AdressBookViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId)!
        cell.textLabel?.text = "\(dataSource[indexPath.row].fileName),speed:\(dataSource[indexPath.row].speed)"
        
        return cell
    }
    
    
}
