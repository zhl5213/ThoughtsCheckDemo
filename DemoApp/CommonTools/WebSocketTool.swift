//
//  WebSocketTool.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/7/24.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit
import HandyJSON
import Starscream

/// message是返回的原始数据，一般是字符串或者data
typealias SocketCompletion = (_ text:String?,_ error:Error?)->()
typealias SocketMessageFilter = (_ text:String)->Bool

enum WebsocketError:CodedError {
    case connectFailed(originError:Error?)
}

struct SocketMessageHandler {
    ///消息内容
    var content:[String:Any]
    /// 服务端收到手机端的消息之后的判断过滤
    var serverResponseFilter:SocketMessageFilter?
    /// 服务端收到手机端的回复之后的回复的回调处理
    var responseCompletion:SocketCompletion?
/// 最后一次消息的response信息；
    var response:SocketResponseModel?
    
    var flagKey:[String] {
        return content.sorted(by: { $0.key > $1.key }).map({ "\($0):\($1)" })
    }
    
}

struct WaitingEvent {
    
    struct FlagKey {
        static let vedioRecordStatusChange:String = "WaitingEvent_vedioRecordStatusChange_2004"
        static let volumeStatusChange:String = "WaitingEvent_volumeStatusChange_2003"
        static let sdCardStatusChange:String = "WaitingEvent_SDCardStatusChange_3000"
        static let autoDeleteMedia:String = "WaitingEvent_MediaAutoDeleteInfo_2002"
        static let deleteMedia:String = "WaitingEvent_deleteMedia_2002"
        static let addVideo:String = "WaitingEvent_addVideo_2005"
        static let addImage:String = "WaitingEvent_addImage_2006"
        static let disconnect:String = "WaitingEvent_1002_disconnectEvent"
        static let deviceAdjust:String = "WaitingEvent_1001_DeviceAdjust"
        static let spaceFull:String = "WaitingEvent_2000_spaceFullEvent"
        static let videoSizeLimit:String = "WaitingEvent_2001_videoSizeLimitEvent"
        static let adjustInfo:String = "WaitingEvent_1003_pictureAdjustInfo"
    }
    
///是轮询的事件还是一次性的；
    var isOneTime:Bool = true
    
    ///事件过滤器，区分事件
    var eventFilter:SocketMessageFilter
    ///   收到事件的回调block
    var eventCompletion:SocketCompletion?
//    ///事件的内容
//    var eventResponse:SocketResponseModel?
    var flagKey:String = ""
    
     ///收到事件之后手机端回复的信息处理
//    var responseMessageHandler:SocketMessageHandler?
    
}

struct PollingEvent {
    
///    轮询是在执行开始请求，还是执行结束请求
    var shouldStart:Bool
//    var startTime:CFTimeInterval = 0
    
///    区分不同轮询的标识符，
    var flagKey:[String] {
        return startMessageHandler.flagKey + endMessageHandler.flagKey
    }
    
    ///    开始轮询发出的消息处理
    var startMessageHandler:SocketMessageHandler

    /////    结束轮询发出的消息处理
    var endMessageHandler:SocketMessageHandler

}



struct SocketResponseModel:HandyJSON {
    
    //    "type": 1000,
    //    "code": $int,  // 0：读取imu参数成功。1：读取imu参数失败。
    //    "error": $string,  // 错误信息。仅当code = 1时才存在该字段。
    //    "data": {
    //    "xbias": $int,  // x轴偏离角度
    //    "ybias": $int,  // y轴偏离角度
    //    "xstatus": $string,  // x轴角度状况。"ok": 角度正常。"error": 角度异常。
    //    "ystatus": $string,  // y轴角度状况。"ok": 角度正常。"error": 角度异常。
    //    }
    var type: Int?
    var code: Int?
    var op:Int?
    var error:String?
    var data:[String:Any]?
    
    func transfromDataToModel<T:HandyJSON>() -> T? {
        return JSONDeserializer<T>.deserializeFrom(dict: data)
    }
    
}

extension Notification.Name {
    struct Websocket {
        static let connected = Notification.Name.init("WebsocketConnected")
        static let disconnected = Notification.Name.init("WebsocketDisconnected")
        static let connectFailed = Notification.Name.init("WebsocketConnectFailed")
    }
}

class WebSocketTool: NSObject {
    
    enum ConnectError:String,Error {
        case Failed = "连接出错"
        case disconnected = "断开连接"
        case timeout = "连接超时"
        
        var localizedDescription: String { return self.rawValue}
    }
    
    let webSocketUrlString = "ws://192.168.42.1:8080/api/v1/device/connection/client"
    
    static let shared = WebSocketTool.init()
    
    lazy var socket:WebSocket = {
        var request = URLRequest(url: URL(string: webSocketUrlString)!)
        request.timeoutInterval = 5
        request.setValue(MEHost.uid, forHTTPHeaderField: "uid")
        
        let socket = WebSocket(request: request)
        
        return socket
    }()
    
    var isConnected:Bool {
        return socket.isConnected
    }
    
    
    let lock = NSRecursiveLock()
    
    var pollingEvents:[PollingEvent] =  [PollingEvent]()
    var waitingEvents:[WaitingEvent] =  [WaitingEvent]()
    var messageHandlers:[SocketMessageHandler] = [SocketMessageHandler]()
    
    var connectSuccessBlock:((_ success:Bool,_ error:CodedError?)->())?
    
    let timeout:TimeInterval = 15
    
    override init() {
        super.init()
        addSocketHandler()
    }
    
    func startConnectToDevice(urlString:String = "ws://192.168.42.1:8080/api/v1/device/connection/client", _ completion:((_ success:Bool,_ error:CodedError?)->())? = nil) -> () {
        //        存在bug，网络切换之后，与上个websocket没有直接断开。所以每次都要重连；
        var request = URLRequest.init(url: URL.init(string: urlString)!)
        request.timeoutInterval = 5
        request.setValue(MEHost.uid, forHTTPHeaderField: "uid")
        socket.request = request
        socket.connect()
        print_Debug(message: "websocket try connect to device ")
        connectSuccessBlock = completion
    }
    
    func stopConnectToDevice() -> () {
        socket.disconnect()
        connectSuccessBlock = nil
    }
    
    private func addSocketHandler() -> () {
        
        socket.onConnect = { [unowned self] in
            print("websocket is connected")
            NotificationCenter.default.post(name: NSNotification.Name.Websocket.connected, object: self.socket)
            if let sccessBlock = self.connectSuccessBlock {
                sccessBlock(true,nil)
                self.connectSuccessBlock = nil
            }
        }
        
        //websocketDidDisconnect
        socket.onDisconnect = { (error: Error?) in
            //            如果sccessBlock还存在，代表此时的disconnect是连接时未连接上的消息
            if let sccessBlock = self.connectSuccessBlock {
                sccessBlock(false,WebsocketError.connectFailed(originError: error))
                self.connectSuccessBlock = nil
                NotificationCenter.default.post(name: NSNotification.Name.Websocket.connectFailed, object: nil, userInfo: nil)
            }else {
                NotificationCenter.default.post(name: NSNotification.Name.Websocket.disconnected, object: self.socket)
            }
            print_Debug(message: "websocket is disconnected: \(String(describing: error?.localizedDescription)),error=\(error)")
        }
        
        //websocketDidReceiveMessage
        socket.onText = { (text: String) in
            
            
            self.lock.lock()
            defer{ self.lock.unlock() }
            
            
            for index in (0..<self.waitingEvents.count).reversed() {
                let waitingEv = self.waitingEvents[index]
                
                if waitingEv.eventFilter(text) {
                    print_Debug(message: "current waitingEvet =\(waitingEv)")
                    
                    if waitingEv.isOneTime {
                        self.waitingEvents.remove(at: index)
                    }
                    
                    if let completion = waitingEv.eventCompletion {
                        if let responseModel = JSONDeserializer<SocketResponseModel>.deserializeFrom(json: text),
                            let code = responseModel.code {
                            if code == 0 {
                                completion(text,nil)
                            }else  {
                                completion(text,ErrorCodeTool.DeviceServerError(rawValue: code))
                            }
                        }else {
                            completion(text,nil)
                        }
                    }
                }
            }
            
            
            for index in (0..<self.messageHandlers.count).reversed() {
                
                let handler = self.messageHandlers[index]
                
                if let filter =  handler.serverResponseFilter,filter(text),let completion = handler.responseCompletion {
                    print_Debug(message: "current handler =\(handler)")
                    
                    self.messageHandlers.remove(at: index)
                    
                    if let responseModel = JSONDeserializer<SocketResponseModel>.deserializeFrom(json: text),
                        let code = responseModel.code {
                        if code == 0 {
                            completion(text,nil)
                        }else  {
                            completion(text,ErrorCodeTool.DeviceServerError(rawValue: code))
                        }
                    }else {
                        completion(text,nil)
                    }
                }
            }
            
            print_Debug(message:"got some text: \(text)")
        }
        //websocketDidReceiveData
        socket.onData = { (data: Data) in
            print_Debug(message:"got some data: \(data.count)")
        }
        
        socket.onHttpResponseHeaders = { (headers) in
            print_Debug(message: "headers =\(headers)")
        }
        
        socket.onPong = { (data) in
            print_Debug(message: "onPong data=\(String(describing: data))")
        }
        
        
    }
    
}


extension WebSocketTool {
    
    
    /// 添加等待事件，添加的时候websocket可以是断开或者不断开。
    /// - Parameter event: 等待服务器端发送数据的事件；
    func addWaitingEvent(_ event:WaitingEvent) -> () {
        guard waitingEvents.contains(where: { $0.flagKey == event.flagKey }) == false else {
            return
        }
        waitingEvents.append(event)
        if socket.isConnected == false {
//            startConnectToDevice()
            print_Debug(message: "websocket is not connected cannot startWaitingEvent")
        }
        print_Debug(message: "startWaitingEvent=\(event)")
    }

    
    func stopWaitingEvent(_ flagKey:String) -> () {
        lock.lock()
        if let index = waitingEvents.firstIndex(where: { $0.flagKey == flagKey }) {
            waitingEvents.remove(at: index)
        }
        lock.unlock()
    }
        
}



//MARK: - pollingEvent (暂时废弃) -
extension WebSocketTool {
    
        func excute(_ messageHandler:SocketMessageHandler) -> () {
            
            guard messageHandlers.contains(where:{ $0.flagKey == messageHandler.flagKey }) == false,socket.isConnected  else {
                return
            }
            
            messageHandlers.append(messageHandler)
            socket.write(string: messageHandler.content.toJsonString())
            
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + timeout) {
                self.lock.lock()
                defer { self.lock.unlock() }
                
                if let handler = self.messageHandlers.first(where: { $0.flagKey == messageHandler.flagKey }),
                    handler.response == nil {
                    
                    let index = self.messageHandlers.firstIndex(where: { $0.flagKey == handler.flagKey })!
                    self.messageHandlers.remove(at: index)
                    
                    DispatchQueue.main.async {
                        if let startCompletion = messageHandler.responseCompletion {
                            startCompletion(nil,ConnectError.timeout)
                        }
                    }
                }
            }
        }
        
        
        func startPollingEvent(_ event:PollingEvent) -> () {
            
            var event = event
            
            event.shouldStart = true
            
            if pollingEvents.contains(where: { $0.flagKey == event.flagKey }) == false {
                pollingEvents.append(event)
            }
            
            if socket.isConnected == false {
    //            startConnectToDevice()
                print_Debug(message: "websocket is not connected cannot startPollingEvent")
            }else {
                socket.write(string: event.startMessageHandler.content.toJsonString())
            }
            
            print_Debug(message: "start polling event=\(event)")
            handTimeout(for: event, isStart: true)

        }
        
        
        func endPollingEvent(_ pEvent:PollingEvent) -> () {
            
            pollingEvents = pollingEvents.map({ (event) -> PollingEvent in
                var newEvent = event
                if newEvent.flagKey == pEvent.flagKey {
                    newEvent.shouldStart = false
                }
                return newEvent
            })
            
            if socket.isConnected {
                socket.write(string: pEvent.endMessageHandler.content.toJsonString())
            }else {
    //            startConnectToDevice()
                print_Debug(message: "websocket is not connected cannot endPollingEvent")
            }
            
            print_Debug(message: "end polling event=\(pEvent)")
           handTimeout(for: pEvent, isStart: false)
        }
        
        
    ///   事件超过时间还没有收到消息，就报超时报错；（注意，有些时间没有超时报错）
       private  func handTimeout(for event:PollingEvent,isStart:Bool) -> () {
        
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + timeout) {
                self.lock.lock()
                defer { self.lock.unlock() }
                
                if let newEvent = self.pollingEvents.first(where: { $0.flagKey == event.flagKey }){
                    
                    let messageHandler = isStart ?  newEvent.startMessageHandler : newEvent.endMessageHandler
                    if  messageHandler.response == nil {
                        //                TODO:此处有逻辑问题，
                        print_Debug(message: "pollingEvent=\(newEvent) isStart=\(isStart),timeout with on response ")
                        
                        let index = self.pollingEvents.firstIndex(where: { $0.flagKey == newEvent.flagKey })!
                        self.pollingEvents.remove(at: index)
                        
                        DispatchQueue.main.async {
                            if let startCompletion = messageHandler.responseCompletion {
                                startCompletion(nil,ConnectError.timeout)
                            }
                        }
                    }
                }
            }
        }
    
}
