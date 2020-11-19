//
//  ChatSessionViewController.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/21.
//

import UIKit


struct SectionModel {
    
    struct SessionData:SessionDataSource {
        func sessionData() -> (avertorImage: UIImage, content: String, isAnother: Bool) {
            return (image,content,isAnother)
        }
        
        var image:UIImage
        var content:String
        var isAnother:Bool
        
    }
    var date:Date
    var cellDatas:[SessionData]
    
}


extension UserInfo:Equatable {
    
    static func ==(left:Self,right:Self)->Bool {
        return left.personName == right.personName
    }
}


extension PersonChatContent {
    
    func createSectionData() -> [SectionModel]? {
        if let allChatContents = chatContents,allChatContents.count > 0 {
            var models = [SectionModel]()
            var date = allChatContents[0].time
            var datas = [SectionModel.SessionData]()
            
            for chatMessage in allChatContents {
                if chatMessage.time <= date + 5 * 60 {
                    let data = SectionModel.SessionData.init(image:chatMessage.user.avatarImage , content: chatMessage.content ?? "", isAnother: chatMessage.user == anotherUser)
                    datas.append(data)
                }else {
                    let sectionModel = SectionModel.init(date: date, cellDatas: datas)
                    models.append(sectionModel)
                    datas.removeAll()
                    date = chatMessage.time
                    let data = SectionModel.SessionData.init(image:chatMessage.user.avatarImage , content: chatMessage.content ?? "", isAnother: chatMessage.user == anotherUser)
                    datas.append(data)
                }
            }
            
            return models
        }else {
            return nil
        }
    }
}



class ChatSessionViewController: UIViewController {
   
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatSessionTableViewCell.self, forCellReuseIdentifier: ChatSessionTableViewCell.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        tableView.backgroundColor = CommonColor.systemBGGray
        return tableView
    }()

    var chatContent:PersonChatContent
    var contentDatas:[SectionModel]?
    
    init(chatContent:PersonChatContent) {
        self.chatContent = chatContent
        super.init(nibName: nil, bundle: nil)
        contentDatas = chatContent.createSectionData()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        tableView.reloadData()
//        if let contentDatas = contentDatas,contentDatas.count > 0 {
//            tableView.scrollToRow(at: IndexPath.init(row: contentDatas.last!.cellDatas.count - 1, section:contentDatas.count - 1), at: .bottom, animated: false)
//        }
    }
    
    func configureSubviews() -> () {
        title = chatContent.anotherUser.personName
        view.addSubview(tableView)
        tableView.mas_makeConstraints { (make) in
            make?.left.right()?.bottom()?.equalTo()
            make?.top.equalTo()(self.mas_topLayoutGuideBottom)
        }
    }

}


extension ChatSessionViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentDatas?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentDatas?[section].cellDatas.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatSessionTableViewCell.reuseID, for: indexPath) as! ChatSessionTableViewCell
        cell.dataSource = contentDatas?[indexPath.section].cellDatas[indexPath.row]
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dateString = contentDatas?[section].date.toString(format: .yyyy_mm_dd_HH_mm_ss)
        let label = UILabel.initWith(text: dateString, font: UIFont.systemFont(ofSize: 13), textColor: UIColor.gray)
        label.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: 44)
        label.backgroundColor = CommonColor.systemBGGray
        return label
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
}
