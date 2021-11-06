//
//  ChatContent.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/20.
//

import UIKit
import AVFoundation

struct UserInfo {
    var personName:String
    var avatarImage:UIImage
    var notifyClose:Bool
}


struct ChatMessage {
    var user:UserInfo
    var content:String?
    var time:Date
    var imageUrlStrings:String?
    var videoUrlStrings:String?
    var moneyAccoutInfo:String?
}


struct PersonChatContent {
    var anotherUser:UserInfo
    var chatContents:[ChatMessage]?
    var lastReadChatContent:ChatMessage?
    
    var hasMesageUnread:Bool{
        AVAudioSession.sharedInstance().currentRoute.outputs
        if let chatContents = chatContents {
            if let trlastReadChatContent = lastReadChatContent {
                if let lastAnotherContent = chatContents.last(where: {  $0.user.personName != anotherUser.personName }),
                   trlastReadChatContent.time < lastAnotherContent.time {
                    return true
                }else {
                    return false
                }
            }else {
                return true
            }
        }else {
            return false
        }
    }
}


struct GroupChatContent {}


extension PersonChatContent:ChatDataSource{
    
    func chatInfos() -> (lefImage: UIImage, hasBage: Bool, title: String, content: String?, time: String?, closeNotify: Bool) {
        return (anotherUser.avatarImage,hasMesageUnread,anotherUser.personName,chatContents?.last?.content,lastReadChatContent?.time.toRandomCalenderString(),anotherUser.notifyClose)
    }
}


extension String {
    
   static  func randowStringWith(count:Int) -> String {
        var string = ""
        for _ in 0..<count {
            let randomStr = String.init(Character.init(Unicode.Scalar.init(0x4E00 + arc4random() % 4000)!))
            string += randomStr
        }
        return string
    }
}


extension Date {
    
    func  toRandomCalenderString() -> String {
        switch arc4random() % 5 {
        case 0:
            return "星期一"
        case 1:
            return "星期二"
        case 2:
            return "星期三"
        case 3:
            return "星期四"
        case 4:
            return "星期五"
        default:
            return "星期天"
        }
    }
}

enum DateFormat {
    ///"yyyy-MM-dd"
    case yyyy_mm_dd
    ///"yyyy-MM-dd HH:mm:ss"
    case yyyy_mm_dd_HH_mm_ss
    case yyyy_mm_dd_HH_mm_ss_SSS
    ///"yyyy/MM/dd"
    case yyyy__mm__dd
    ///"yyyy/MM/dd HH:mm:ss"
    case yyyy__mm__dd_HH_mm_ss
    case other(custom:String)
    
    func formatString() -> String {
        switch self {
        case .yyyy_mm_dd:
            return "yyyy-MM-dd"
        case .yyyy_mm_dd_HH_mm_ss:
            return "yyyy-MM-dd HH:mm:ss"
        case .yyyy_mm_dd_HH_mm_ss_SSS:
            return "yyyy-MM-dd HH:mm:ss:SSS"
        case .yyyy__mm__dd:
            return "yyyy/MM/dd"
        case .yyyy__mm__dd_HH_mm_ss:
            return "yyyy/MM/dd HH:mm:ss"
        case .other(custom:let format):
            return format
        }
    }
}

extension Date {
    
    func toString(format: DateFormat = .yyyy__mm__dd) -> String {
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format.formatString()
        
        return dateFormatter.string(from: self)
    }
    
    static func -(lhs:Date,rhs:Date) -> TimeInterval {
        return lhs.timeIntervalSince(rhs)
    }
    
}

extension UserInfo {
    
   static  func randomInfo() -> UserInfo {
        return UserInfo.init(personName: String.randowStringWith(count: Int(arc4random() % 15 + 1)), avatarImage: UIImage.createRandomColorImage(imageSize: CGSize.init(width: 44, height: 44)), notifyClose: arc4random() % 2 == 1)
    }
}


extension ChatMessage {
    
    static func randomMessageWith(userInfo:UserInfo)->ChatMessage {
        return ChatMessage.init(user: userInfo, content:String.randowStringWith(count: Int(arc4random() % 100 + 1)), time: Date.init(timeIntervalSince1970: TimeInterval.init(arc4random() % (24 * 3600))), imageUrlStrings: nil, videoUrlStrings: nil, moneyAccoutInfo: nil)
    }
}



extension PersonChatContent {
    
    static func randomPersonChatContent(myUserInfo:UserInfo)->PersonChatContent {
        
        let anotherUsrInfo = UserInfo.randomInfo()
        var chatContents = [ChatMessage]()
        
        var startDate = Date.init(timeIntervalSinceNow: TimeInterval.init(arc4random() % (24 * 3600 * 30)))
        
        for _ in 0..<(arc4random() % 100 + 10) {
            var userInfo = myUserInfo
            if arc4random() % 2 == 1 {
                userInfo = anotherUsrInfo
            }
            let timeInterval:TimeInterval = {
                if arc4random() % 2 == 1 {
                    return TimeInterval(arc4random() % (5 * 60))
                }else {
                    return TimeInterval(arc4random() % (60 * 60))
                }
            }()
            
            startDate.addTimeInterval(timeInterval)

            var chatMessage = ChatMessage.randomMessageWith(userInfo: userInfo)
            chatMessage.time = startDate
            chatContents.append(chatMessage)
        }
        
        var lastReadContent = chatContents[ Int(arc4random()) % chatContents.count ]
        
        if arc4random() % 3 == 1 {
            lastReadContent = chatContents.last!
        }
        
        return PersonChatContent.init(anotherUser: anotherUsrInfo, chatContents: chatContents, lastReadChatContent: lastReadContent)
    }
}




class ChatContentManager: NSObject {
    
    static let shared:ChatContentManager = ChatContentManager.init()
    var myInfo = UserInfo.randomInfo()
    
    func getAllChatContents(completion:@escaping (_ chatDataSource:[ChatDataSource])->()) -> () {
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
            
            var personChatContents = [PersonChatContent]()
            
            for _ in 0..<100 {
                let randomContent = PersonChatContent.randomPersonChatContent(myUserInfo: self.myInfo)
                personChatContents.append(randomContent)
            }
            completion(personChatContents)
        }
    }
}
