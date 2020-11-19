////
////  NetworkService.swift
////  anjet charger
////
////  Created by 朱慧林 on 2018/6/29.
////  Copyright © 2018年 Anjet. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import os
//import HandyJSON
//import SystemConfiguration.CaptiveNetwork
//import NetworkExtension
//
//let sessionErrorCode:Int = ErrorCodeTool.NetError.sessionError.rawValue
//
//enum NetworkServiceError:CodedError {
//    case responseEmpty
//    case decodeResponseStringFailure(statusCode:Int?)
//    case deserilizeResponseFailure(statusCode:Int?)
//    case unlogin
//    case encodeDataError
//    case sessionError
//    case websocketDisconnect
//    case needResumeError
//    case notFound
//    case thirdPartyUnkownError(error:Error?)
//    case other(code:Int?,message:String?)
//
//    func description() -> String {
//        var errorMsg:String
//        switch self {
//        case .responseEmpty:
//            errorMsg = "数据响应为空"
//        case .decodeResponseStringFailure:
//            errorMsg = "数据解码失败"
//        case .sessionError:
//            errorMsg = "登录信息过期"
//        case .encodeDataError:
//            errorMsg = "编码数据出错"
//        case .unlogin:
//            errorMsg = "请登录"
//        case .other( _,let message):
//            errorMsg = message ?? "数据错误，请重试"
//        case .thirdPartyUnkownError(_):
//            errorMsg = "第三方未知错误"
//        default:
//            errorMsg = "未知错误,请重试"
//        }
//        return errorMsg  + ErrorCodeTool.codeSuffix(self)
//    }
//    var localizedDescription: String {return self.description()}
//}
//
//typealias DownloadCompletion<V,R> = (_ responseValue:V?,_ error:CodedError?,_ response:DownloadResponse<R>?)->()
//
//typealias NetworkCompletion = (_ data:[String:Any]?,_ error:CodedError?,_ response:DataResponse<Any>?)->()
//typealias DataNetworkCompletion = (_ data:Data?,_ error:CodedError?,_ response:DataResponse<String>?)->()
//typealias StringNetworkCompletion = (_ data:String?,_ error:CodedError?,_ response:DataResponse<String>?)->()
//typealias LoadProgressHandle = ((_ progress:Progress)->())
//
//
//class HTTPNetworkTool: BasicTool {
//
//    static let shared:HTTPNetworkTool = {
//        let instance = HTTPNetworkTool()
//        return instance
//    }()
//
//
//
//    let quickRequestTimeOut:TimeInterval = 8
//
//    ///超时时间8秒
//    lazy var fastSessionManager:SessionManager = {
//        return createSessionManager(timeOut: quickRequestTimeOut)
//    }()
//
//    ///超时时间15秒
//    lazy var sessionManager:SessionManager = {
//        return createSessionManager(timeOut: 15)
//    }()
//
//    ///超时时间30秒
//    lazy var slowSessionManager:SessionManager = {
//        return createSessionManager(timeOut: 30)
//    }()
//
//    private func createSessionManager(timeOut:TimeInterval)->SessionManager {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = timeOut
//        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
//        //get方法默认会使用缓存，导致数据改变之后拿不到最新的数据，所以要修改缓存策略；
//        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//
//        return Alamofire.SessionManager.init(configuration: configuration)
//    }
//
//    enum ResponseSpeed {
//        case fast
//        case normal
//        case slow
//    }
//
//    lazy var reachablityManagers:[String:NetworkReachabilityManager] = [MEHost.deviceHostName:self.networkReachablityManager!]
//    lazy var networkReachablityManager = NetworkReachabilityManager.init(host: MEHost.deviceHostName)
//
//    //单元测试完成；
//    private func handleResponseJson(parameters:[String:Any]? = nil,response:DataResponse<Any>,jsonComplete:NetworkCompletion?){
//        if let resp = response.response {
//            print_Debug(message: "responseJSON has response resp.statusCode \(resp.statusCode) \n resp.allHeaderFields \(resp.allHeaderFields)\n resp.request.url \(String(describing: response.request?.url))")
//        }
//        if response.error != nil || response.value == nil || response.data == nil {
//            let error = response.error
//            print_Debug(message: "responseJSON has error, request \(String(describing: response.request))\n error=\(String(describing: error)),responseValue=\(response.value), resp.data=\(String.init(data: response.data!.prefix(1000), encoding: .utf8) ?? "nil")")
//            if let nsError = error as? CFNetworkErrors {
//                jsonComplete.map({ $0(nil,nsError,nil) })
//            }else if let urlError = error as? URLError {
//                jsonComplete.map({ $0(nil,urlError,nil) })
//            } else if let afnError = error as? AFError {
//                jsonComplete.map({ $0(nil,afnError,nil) })
//            }else {
//                jsonComplete.map({ $0(nil,NetworkServiceError.thirdPartyUnkownError(error: error),nil) })
//            }
//        } else {
//            let responseValue = response.value
//            if let json = responseValue as? [String:Any] ,let code = json["code"] as? Int{
//                print_Debug(message: "responseJSON is json, responseValue=\(json.descriptionWithCountLimit(1000))")
//                if code == 0 {
//                    //成功
//                    jsonComplete.map({ $0(json,nil,response) })
//                } else if code == 200 && response.request?.url?.host == URL.init(string: MEHost.deviceC8Host)!.host {
//                    jsonComplete.map({ $0(json,nil,response) })
//                }  else if code == sessionErrorCode {
//                    //sessionerror： require login
//                    jsonComplete.map({ $0(json,NetworkServiceError.sessionError,response)})
//                } else {
//                    if response.request?.url?.host == URL.init(string: MEHost.deviceHost)!.host  {
//                        var error:CodedError? = ErrorCodeTool.DeviceServerError.init(rawValue:code) as CodedError?
//                        if error == nil {
//                            error = NetworkServiceError.other(code:code, message: json["error"] as? String)
//                        }
//                        jsonComplete.map({$0(json,error,response)})
//                    } else {
//                        jsonComplete.map({ $0(json,NetworkServiceError.other(code:code, message: json["error"] as? String),response)})
//                    }
//                }
//            } else {
//                print_Debug(message: "responseJSON is not json, responseValue=\(String(describing: responseValue))")
//                if responseValue == nil {
//                    jsonComplete.map({ $0(nil,NetworkServiceError.responseEmpty,response)})
//                }else {
//                    jsonComplete.map({ $0(nil,NetworkServiceError.decodeResponseStringFailure(statusCode:response.response?.statusCode),response)})
//                }
//            }
//        }
//
//    }
//
//    private func sessionManager(for type:ResponseSpeed) -> SessionManager {
//        switch type {
//        case .fast:
//            return fastSessionManager
//        case .normal:
//            return sessionManager
//        case .slow:
//            return slowSessionManager
//
//        }
//    }
//
//    ///单元测试完成
//    /// 除了上传、下载的网络请求destination接口
//    /// - Parameters:
//    ///   - responseSpeed: 可选择快速（8秒超时）、通常（15秒超时）、慢（30秒超时）三种
//    ///   - host: 域名地址字符串；例如 "https://argus.minieye.tech" 或者"http://192.168.42.1:8080"
//    ///   - path: 请求路径,例如/SD0/self_vp_123.jpg
//    ///   - method: 请求方法类型，默认是nil。
//    ///   - parameters: 请求参数，为Dictionary格式,默认是nil
//    ///   - jsonComplete: json格式completion回调
//    ///   - stringComplete: string格式completion回调
//    /// - Returns: dataRequest。
//    @discardableResult
//    func connectToServer(responseSpeed:ResponseSpeed = .normal,
//                         host:String,
//                         path:String,
//                         method:HTTPMethod = .post,
//                         parameters:[String:Any]? = nil,
//                         with jsonComplete:NetworkCompletion?,
//                         stringComplete:StringNetworkCompletion? = nil) -> DataRequest {
//
//        var headers:HTTPHeaders = SessionManager.defaultHTTPHeaders
//        if host == MEHost.deviceHost {
//            headers.merge(["uid":MEHost.uid], uniquingKeysWith: { return $1 })
//        }
//        let manager = sessionManager(for: responseSpeed)
//
//        let request = manager.request(host + path,
//                               method: method,
//                               parameters: parameters,
//                               encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
//                               headers: headers)
//            .responseJSON { (response) in
//
//                self.handleResponseJson(parameters: parameters, response: response, jsonComplete: jsonComplete)
//
//        }.responseString { (response) in
//
//            guard stringComplete != nil else { return }
//
//            if let resp = response.response {
//                print_Debug(message: "responseString resp.statusCode \(resp.statusCode) \n resp.allHeaderFields \(resp.allHeaderFields)")
//            }
//
//            if response.error != nil || response.value == nil || response.data == nil {
//                let error = response.error
////                print_Debug(message:"[NetWork Service]responseString ,error=\(String(describing: error))")
//                if let nsError = error as? CFNetworkErrors {
//                    stringComplete.map({ $0(nil,nsError,nil) })
//                } else if let afnError = error as? AFError {
//                    stringComplete.map({ $0(nil,afnError,nil) })
//                } else if let urlError = error as? URLError {
//                    stringComplete.map({ $0(nil,urlError,nil) })
//                }else {
//                    stringComplete.map({ $0(nil,NetworkServiceError.thirdPartyUnkownError(error: error),nil) })
//                }
//            } else {
//                let responseValue = response.value
//                if let json = responseValue {
//                    print_Debug(message:"[NetworkService] responseString responseValue=\(String(describing: json.prefix(1000)))")
//                    if let model = JSONDeserializer<NetworkDataModel<BasicModel>>.deserializeFrom(json: json) {
//
//                        if  model.code == 0 {
//                            //成功
//                            stringComplete.map({ $0(json,nil,response)})
//
//                        } else if  model.code == sessionErrorCode {
//                            //sessionerror： require login
//                            stringComplete.map({$0(json,NetworkServiceError.sessionError,response)})
//                        } else {
//                            if response.request?.url?.host == URL.init(string: MEHost.deviceHost)!.host  {
//                                stringComplete.map({$0(json,ErrorCodeTool.DeviceServerError.init(rawValue: model.code!),response)})
//                            }else {
//                                stringComplete.map({$0(json,NetworkServiceError.other(code:model.code, message: model.error),response)})
//                            }
//                        }
//                    } else {
//                        stringComplete.map({$0(json,NetworkServiceError.deserilizeResponseFailure(statusCode:response.response?.statusCode),response)})
//                        if response.request?.url?.host == URL.init(string: MEHost.deviceHost)!.host, response.response?.statusCode == 401, WebSocketTool.shared.socket.isConnected {
//                            WebSocketTool.shared.startConnectToDevice(nil)
//                        }
//                    }
//                } else {
//                    print_Debug(message:"[NetworkService] responseString responseValue=\(String(describing: responseValue))")
//                    if responseValue == nil {
//                        stringComplete.map({$0(nil,NetworkServiceError.responseEmpty,response)})
//                    }else {
//                        stringComplete.map({$0(nil,NetworkServiceError.decodeResponseStringFailure(statusCode:response.response?.statusCode),response)})
//                    }
//                }
//            }
//        }
//
//        print_Debug(message: "responseJSON start url request \(String(describing: request.request)) param=\(parameters.map({ $0.descriptionWithCountLimit(1000)}))  ")
//        request.validate(statusCode: 200...299)
//        return request
//    }
//
//    func multformDataUpload(host:String,
//                            path:String,
//                            file:(url:URL,name:String)? = nil,
//                            files:[(data:Any,name:String)]? = nil,
//                            parameters:[String:String]?,
//                            uploadRequest:((_ request:UploadRequest) -> Void)? = nil,
//                            uploadProgress:((_ progress:Progress) -> Void)? = nil,
//                            complete:NetworkCompletion?) {
//        var headers:HTTPHeaders = SessionManager.defaultHTTPHeaders
//        if host == MEHost.deviceHost {
//            headers.merge(["uid":MEHost.uid], uniquingKeysWith: { return $1 })
//        }
//
//        Alamofire.upload(multipartFormData: { (formData) in
//            if let _ = parameters {
//                for (key,value) in parameters! {
//                    formData.append(value.data(using: .utf8)!, withName: key)
//                }
//            }
//            if let tFile = file {
//                formData.append(tFile.url, withName: tFile.name)
//            }
//            if let tFiles = files {
//                tFiles.forEach { (item) in
//                    if let url:URL = item.data as? URL {
//                        formData.append(url, withName: item.name)
//                    }
//                    if let data:Data = item.data as? Data {
//                        formData.append(data, withName: item.name)
//                    }
//                }
//            }
//        }, to: host + path,
//           method: .post,
//           headers: headers) { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                if let _ = uploadProgress {
//                    upload.uploadProgress { (progress) in
//                        uploadProgress!(progress)
//                    }
//                }
//
//                upload.responseJSON { response in
//                    debugPrint(response)
//                    self.handleResponseJson(parameters: parameters, response: response, jsonComplete: complete)
//                }
//
//                uploadRequest.map{$0(upload)}
//
//            case .failure(let encodingError):
//                print_Debug(message:"encodingError=\(encodingError)")
//                complete.map({ $0(nil,NetworkServiceError.encodeDataError,nil)})
//            }
//        }
//    }
//
//
//    func resumeDataStoreUrl(destinationURL:URL,originPath:String) -> URL {
//        let directory = destinationURL.deletingLastPathComponent()
//        let md5 = (directory.absoluteString + originPath).md5
//        let resumDataUrl = directory.appendingPathComponent("resumDataDirectory",isDirectory: true).appendingPathComponent("resumeData_" + md5)
//        return resumDataUrl
//    }
//
//
//    @discardableResult
//    func download<V,R>(host:String,
//                       path:String,
//                       parameters:[String:Any]? = nil,
//                       to destinationURL:URL,
//                       downloadProgress:((_ progress:Progress)->(Void))? = nil ,
//                       with downloadComplete:DownloadCompletion<V,R>?) -> DownloadRequest {
//
//        var headers:HTTPHeaders = SessionManager.defaultHTTPHeaders
//        if host == MEHost.deviceHost {
//            headers.merge(["uid":MEHost.uid], uniquingKeysWith: { return $1 })
//        }
//
//        var originResumeData:Data?
//        let resumDataUrl = resumeDataStoreUrl(destinationURL:destinationURL,originPath:host+path)
//
//        LocalFileTool.shared.files(at:resumDataUrl, type: Data.self) { (success, error, dataArray) in
//            if  success,let dataAr = dataArray as? [Data] {
//                originResumeData = dataAr.last
//            }
//        }
//        var downloadRequest:DownloadRequest?
//
//        if let resumData = originResumeData {
//            downloadRequest =  Alamofire.download(resumingWith: resumData){(url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//                return (destinationURL, [.createIntermediateDirectories, .removePreviousFile])
//            }
//        }else{
//            downloadRequest = Alamofire.download(host + path,
//                                                 method: .get,
//                                                 parameters: parameters,
//                                                 encoding: URLEncoding.default,
//                                                 headers: headers)
//            { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//                return (destinationURL, [.createIntermediateDirectories, .removePreviousFile])
//            }
//        }
//        downloadRequest!.validate(statusCode: 200..<300)
//
//        if let _ = downloadProgress {
//            downloadRequest!.downloadProgress{ progress in
////                print_Debug(message:"Download Progress: \(progress.fractionCompleted)")
//                downloadProgress.map{$0(progress)}
//            }
//        }
//
//        if let jsonResponComplete = downloadComplete as? ([String:Any]?,CodedError?,DownloadResponse<Any>?)->() {
//
//            downloadRequest!.responseJSON { (response) in
//                self.excute(downloadResponse: response, resumeDataUrl: resumDataUrl, with: jsonResponComplete)
//            }
//        }else if let stringResponComplete = downloadComplete as? (String?,CodedError?,DownloadResponse<String>?)->() {
//            downloadRequest!.responseString { (response) in
//                self.excute(downloadResponse: response, resumeDataUrl: resumDataUrl, with: stringResponComplete)
//            }
//        }else if let dataResponComplete = downloadComplete as? (Data?,CodedError?,DownloadResponse<Data>?)->() {
//            downloadRequest!.responseData { (response) in
//                self.excute(downloadResponse: response, resumeDataUrl: resumDataUrl, with: dataResponComplete)
//            }
//        }
//        return downloadRequest!
//    }
//
//
//
//    private func excute<V,R>(downloadResponse:DownloadResponse<R>,resumeDataUrl:URL,with complete:@escaping DownloadCompletion<V,R>) -> () {
//        var finalValue:V?
//        var finalError:CodedError?
//
//        func parseResp() {
//            var finalResponseValue:Any?
//            var finalCode:Int?
//            if let response = downloadResponse as? DownloadResponse<String>  {
//                if  let json = response.value ,let code = JSONDeserializer<NetworkDataModel<BasicModel>>.deserializeFrom(json: json)?.code  {
//                    finalResponseValue = json
//                    finalCode = code
//                }
//                setErrorAndValue(responseValue: finalResponseValue, code: finalCode)
//            }else if let response = downloadResponse as? DownloadResponse<Any>, V.self == [String:Any].self  {
//                if  let json = response.value as? [String:Any] ,let code = json["code"] as? Int  {
//                    finalResponseValue = json
//                    finalCode = code
//                }
//                setErrorAndValue(responseValue: finalResponseValue, code: finalCode)
//            }
//
//            if let dataResponse = downloadResponse as? DownloadResponse<Data>,let  data = dataResponse.value {
//                finalValue = data as? V
//            }
//            print_Debug(message:"download success, excute downloadResponse  request \(String(describing: downloadResponse.request)) \n responseValue=\(String(describing:finalValue))")
//
//        }
//
//        func setErrorAndValue(responseValue:Any?,code:Int?) {
//
//            if  let json = responseValue {
//                if  code == 0 {
//                    //成功
//                } else if code == sessionErrorCode {
//                    //sessionerror： require login
//                    finalError = NetworkServiceError.sessionError
//                } else {
//                    finalError = NetworkServiceError.thirdPartyUnkownError(error: nil)
//                }
//                finalValue = json as? V
//            } else {
//                if responseValue == nil {
//                    finalError = NetworkServiceError.responseEmpty
//                }else {
//                    finalError = NetworkServiceError.decodeResponseStringFailure(statusCode:nil)
//                }
//            }
//        }
//
//        if downloadResponse.error != nil || downloadResponse.value == nil  {
//            print_Debug(message:"[NetWorkService] download task error ,response request \(String(describing: downloadResponse.request)) error=\(downloadResponse.error!.localizedDescription))")
//
//            if let newResumeData = downloadResponse.resumeData,newResumeData.count > 0 {
//                //主动取消 返回NSError code -999 NSURLErrorCancelled，返回自定义错误 NetworkServiceError.needResumeError
//                print_Debug(message: "downloadResponse.resumeData.count =\(String(describing: downloadResponse.resumeData)),will staore Resume data local")
//                storeResumeDataAtLocal(downloadResponse, url: resumeDataUrl )
//                finalError = NetworkServiceError.needResumeError
//            }else{
//                let error = downloadResponse.error
//                //                print_Debug(message:"[NetWork Service]responseString ,error=\(String(describing: error))")
//                if let nsError = error as? CFNetworkErrors {
//                    finalError = nsError
//                } else if let afnError = error as? AFError {
//                    finalError = afnError
//                }else if let urlError = error as? URLError {
//                    finalError = urlError
//                }else {
//                    finalError = NetworkServiceError.thirdPartyUnkownError(error: error)
//                }
//            }
//            if let tError = downloadResponse.error as? AFError, case AFError.responseValidationFailed(_) = tError {
//                finalError = NetworkServiceError.other(code: tError.responseCode, message: String.localized_Failed_Get_Data_Try_Again)
//            }
//        } else {
//            parseResp()
//        }
//
//        complete(finalValue,finalError,downloadResponse)
//    }
//
//
//
//    private  func storeResumeDataAtLocal<R>(_ response:DownloadResponse<R>,url:URL) -> () {
//
//        if let newResumeData = response.resumeData,newResumeData.count > 0 {
//            LocalFileTool.shared.createLocalDirectorys(urls: [url])
//            let directory = url.deletingLastPathComponent()
//
//            LocalFileTool.shared.store(at: directory, namesAndContents: [url.lastPathComponent : newResumeData], complete: { (success, error, unStoreNames) in
//                if let tError = error {
//                    print_Debug(message: "store resumDataUrl.lastPathComponent =\(url.lastPathComponent),error =\(tError)")
//                }else{
//                    print_Debug(message: "store resumDataUrl.lastPathComponent =\(url.lastPathComponent) success")
//                }
//            })
//        }
//    }
//
//}
//
//extension Dictionary where Key == String,Value == Any {
//
//
//    func descriptionWithCountLimit(_ count:Int) -> Dictionary {
//        var newDic = self
//        for (key,value) in self {
//            if let str = value as? String,str.count > count {
//                newDic[key] = str.subString(start: 0, length:count) + "………………未完待续"
//            }else if let data = value as? Data,data.count > count  {
//                newDic[key] = data.subdata(in: Range<Data.Index>.init(NSRange.init(location: 0, length: count))!)
//            }else if let dic = value as? Dictionary {
//                newDic[key] = dic.descriptionWithCountLimit(count)
//            }
//        }
//        return newDic
//    }
//
//}
//
//
////MARK: - cloudService -
//extension HTTPNetworkTool {
//
//
//
//    func requestToClouldServer(host:String? = MEHost.host,
//                               path:String,
//                               method:HTTPMethod? = .post,
//                               parameters:[String:Any]? = nil,
//                               with complete:@escaping (NetworkCompletion)) -> () {
//        self.connectToServer(host: host!,
//                             path: path,
//                             method: method!,
//                             parameters: parameters,
//                             with: complete)
//    }
//
//
//    func getToClouldServer(host:String? = MEHost.host,
//                           path:String,
//                           parameters:[String:Any]? = nil,
//                           with complete:@escaping (NetworkCompletion)) -> () {
//        self.connectToServer(host: host!,
//                             path: path,
//                             method: .get,
//                             parameters: parameters,
//                             with: complete)
//    }
//
//
//    func postToClouldServer(host:String? = MEHost.host,
//                            path:String,
//                            parameters:[String:Any]? = nil,
//                            with complete:@escaping (NetworkCompletion)) -> () {
//        self.connectToServer(host: host!,
//                             path: path,
//                             parameters: parameters,
//                             with: complete)
//    }
//}
//
////MARK:- device service -
//extension HTTPNetworkTool {
//
//    /// 从设备服务器使用断点下载数据；这个函数是泛型函数，目前实现了ResponseJson(responseValue是字典，DownloadResponse<Any>)、ResponseString(responseValue是String，DownloadResponse<String>)、ResponseData(responseValue是Data，DownloadResponse<Data>)
//    /// - 下载前: 下载前会在destinationURL文件夹下面寻找是否有resumeData，如果有就进行断点下载；如果没有，就是普通下载；
//    /// - 下载后:出现错误后，如果有resumeData，就将resumeData放在destinationURL文件夹下面；
//    @discardableResult
//    func downloadFromDeviceServer<V,R>(relativeUrlPath:String, parameters:[String:Any]? = nil,to destinationURL:URL,with complete:@escaping DownloadCompletion<V,R>) -> DownloadRequest {
//
//        var completion = complete
//        completion = { (responseValue,error,downloadResponse) in
//
//            if let dataResponse = downloadResponse as? DownloadResponse<Data>,let data = dataResponse.value {
//
//                //                如果data数据可以转化为Json，说明下载失败，此时返回的是服务器传过来的错误信息；
//                if let errorJson = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any],
//                    let code = errorJson["code"] as? Int  {
//                    print_Debug(message: "download response errorJson=\(String(describing: errorJson))")
//                    if let serverError = ErrorCodeTool.DeviceServerError.init(rawValue: code) {
//                        complete(nil,serverError,downloadResponse)
//                    }else{
//                        complete(nil,NetworkServiceError.thirdPartyUnkownError(error: error),downloadResponse)
//                    }
//                }else{
//                    complete(data as? V ,error,downloadResponse)
//                }
//                print_Debug(message: "dataResponse=\(data)")
//            }else{
//                complete(responseValue,error,downloadResponse)
//            }
//        }
//
//        return  self.download(host: MEHost.deviceHost, path: relativeUrlPath, parameters: parameters, to: destinationURL, with: completion)
//    }
//
//    /// 1.连接设备服务器；
//    /// 2.error == nil时网络请求成功，否则失败；只有json中的code ==0才会error == nil；error是通过code来定义的，它只有两种类型，一种是ErrorCodeTool中的DeviceServerError,属于设备服务器判断发送的请求执行错误；第二种是NetworkServiceError，是App自定义的错误类型，包含数据解析错误、数据为空或者错误码不是设备服务器返回的等情况；
//    ///3.json 是最原始的dictionary数据结构,只要网络请求有数值返回就存在；resp是alamofire返回的response<Any>；
//    @discardableResult
//    func connectToDeviceServer(responseSpeed:HTTPNetworkTool.ResponseSpeed = .normal,method:HTTPMethod = .post,path:String, parameters:[String:Any]? = nil,with stringComplete:StringNetworkCompletion?, jsonComplete:NetworkCompletion? = nil) -> DataRequest {
//        if needDeviceWebsocketConnect(for: path),WebSocketTool.shared.socket.isConnected == false {
//            var headers = SessionManager.defaultHTTPHeaders
//            headers.merge(["uid":MEHost.uid], uniquingKeysWith: { return $1 })
//            stringComplete?(nil,NetworkServiceError.websocketDisconnect,nil)
//            jsonComplete?(nil,NetworkServiceError.websocketDisconnect,nil)
//            print_Debug(message: "needDeviceWebsocketConnect path =\(path) ,but websoket is not connected")
//            return sessionManager(for: responseSpeed).request(MEHost.deviceHost + path,
//            method: method,
//            parameters: parameters,
//            encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
//            headers: headers)
//        }else {
//            return connectToServer(responseSpeed:responseSpeed,host:  MEHost.deviceHost, path: path, method: method, parameters: parameters, with: jsonComplete,stringComplete:stringComplete)
//        }
//    }
//
//    func needDeviceWebsocketConnect(for path:String) -> Bool {
//        if  DeviceManagementManger.DeviceUrlPath.notNeedConnectWebsocketPath.contains(path) {
//            return false
//        }else {
//            return true
//        }
//    }
//
//
//}
//
////MARK:- wifi check -
//extension HTTPNetworkTool {
//
//
//    enum ReachableError:String,Error {
//        case getSSIDFailed = "获取ssid失败"
//        case isUnreachable = "网络不可用"
//        var localizedDescription: String{ return self.rawValue }
//    }
//
//    enum NEHotspotConnectError:String,Error {
//        case configureSuccessNotConnect = "配置成功，但是没有直接连上"
//        case userDenied = "用户拒绝"
//        case otherError = "其他错误"
//        case systemVersionTooLow = "系统版本太低"
//        case systemNotResponse = "系统不响应"
//        var localizedDescription: String{ return self.rawValue }
//    }
//
//    static var wifiFetchTimerInfos:[TimerInfo] = [TimerInfo]()
//
//    struct TimerInfo {
//        var timer:Timer?
//        var count:Int = 0
//    }
//
//    ///单元测试完成
//    /// 获取当前wifi的ssid，获取不到返回nil。注意：iOS11之后，iPHone有系统bug，有可能无法拿到wifissid。
//    /// - Returns: ssid字符串
//    func getSystemWifiSSID() -> String? {
//        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
//            for interface in interfaces {
//                print_Debug(message: "interface =\(interface)")
//                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
//                    print_Debug(message: "interfaceInfo=\(interfaceInfo)")
//                    return interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
//                }else{
//                    print_Debug(message: "getCurrentWifiSSID get ssid failed ，CNCopyCurrentNetworkInfo(interface as! CFString) =\(String(describing: CNCopyCurrentNetworkInfo(interface as! CFString)))")
//                    return nil
//                }
//            }
//        }else{
//            return nil
//        }
//        return nil
//    }
//
//
//    ///单元测试完成
//    /// 第一步，判断是否授权，如果用户拒绝授权执行错误回调；第二步，如果用户同意授权，就使用timer，多次获取wifiSsid；
//    /// 第三步，拿到ssid或者timer超时（2秒，0.5秒请求一次）都执行最后一步回调；
//    /// 支持多个请求同时执行；
//    /// - Parameter completion: 回调，第一个参数是ssid，第二个是错误信息
//    func authorizeAndPollingToGetCurrentWifiSSID(completion:@escaping (_ ssid:String?,_ error:Error?)->()){
//        LocationTool.shared.requestCLAuthorization { (success, error) in
//            if success {
//
//                let timer = Timer.init(timeInterval: 0.5, repeats: true) { [weak self] (timer) in
//                    guard let self = self else { return }
//                    if var timerInfo = HTTPNetworkTool.wifiFetchTimerInfos.first(where: { $0.timer == timer }),let index = HTTPNetworkTool.wifiFetchTimerInfos.firstIndex(where: { $0.timer == timer }) {
//
//                        timerInfo.count += 1
////                        print_Debug(message: "timerInfo =\(timerInfo)")
//
//                        if timerInfo.count > Int(2/0.5) {
//                            timerInfo.timer?.invalidate()
//                            timerInfo.timer = nil
//                            HTTPNetworkTool.wifiFetchTimerInfos.remove(at: index)
//                            completion(nil,ReachableError.getSSIDFailed)
////                            print_Debug(message: "after 5 times repeat fetch, wifi ssid failed to got")
//                            return
//                        }
//
//                        if let ssid = self.getSystemWifiSSID() {
//                            timerInfo.timer?.invalidate()
//                            timerInfo.timer = nil
//                            HTTPNetworkTool.wifiFetchTimerInfos.remove(at: index)
//                            completion(ssid,nil)
//                            return
//                        }
//
//                        HTTPNetworkTool.wifiFetchTimerInfos.replaceSubrange(index...index, with: [timerInfo])
//                    }
//                }
//
//                RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
//                timer.fire()
//                HTTPNetworkTool.wifiFetchTimerInfos.append(TimerInfo.init(timer: timer, count: 0))
//            }else{
//                completion(nil,error)
//            }
//        }
//    }
//
//    ///单元测试完成；
//    /// 有四种结果：1是连接成功，2是用户拒绝，3是配置成功但是连接失败，此时系统弹出提示框“无法加入网络“MINIEYE-””；4是其他的配置失败；
//    /// - Parameters:
//    ///   - deviceInfo: 设备信息
//    ///   - completion: success表示连接成功，包括配置成功并连上、配置失败但是已经连接两种情况；其他的情况都是连接失败，包括配置成功但是没有连上，所有其他的配置失败等情况
//    func connectDeviceWifiWithNEHotSpot(deviceInfo:HardwareDeviceInfo,completion:@escaping (_ success:Bool,_ error:Error?)->()) -> () {
//
//        let wifiConnectLock = NSLock()
//
//        if #available(iOS 11.0, *) {
//            let manager = NEHotspotConfigurationManager.shared
//            let config = NEHotspotConfiguration(ssid: deviceInfo.wifiSSID!,
//                                                passphrase: "1234567890",
//                                                isWEP: false)
//            var configureWifiCompleted = false
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
//                wifiConnectLock.lock()
//                print_Debug(message: "wifi配置超时回调，configureWifiCompleted is \(configureWifiCompleted),wifiConnectLock=\(wifiConnectLock)")
//                if configureWifiCompleted == false {
//                    configureWifiCompleted = true
//                    completion(false,NEHotspotConnectError.systemNotResponse)
//                }
//                wifiConnectLock.unlock()
//            })
//
//            manager.apply(config) { [unowned self] (error) in
//                wifiConnectLock.lock()
//                guard configureWifiCompleted == false else { return }
////                使用NEHotspotConfigurationErrorDomain在iPhone 6上有一定的概率直接报错（设备清空授权之后）；出现badAddress,不能访问的错误。
//                if let tError = error as NSError? {
//                    if tError.domain == "NEHotspotConfigurationErrorDomain"  {
//                        switch tError.code {
//                        case 7:
//                            completion(false,NEHotspotConnectError.userDenied)
//                            break
//                        case 13:
//                            //                        已经连上了；
//                            completion(true,nil)
//                            break
//                        default:
//                            completion(false,NEHotspotConnectError.otherError)
//                            break
//                        }
//                    } else {
//                        completion(false,NEHotspotConnectError.otherError)
//                    }
//
//                    print_Debug(message: "wifi配置失败，terror=\(tError),wifiConnectLock=\(wifiConnectLock)")
//                }else {
//                    // 判断ssid是否和当前的连接的Wi-Fi ssid一致，一致则连接成功，否则失败
//                    let ssid = HTTPNetworkTool.shared.getSystemWifiSSID()
//                    if ssid == deviceInfo.wifiSSID! {
//                        print_Debug(message: "wifi配置成功而且连接上了,wifiConnectLock=\(wifiConnectLock)")
//                        completion(true,nil)
//                    } else {
////                        配置成功，但是没有连接上Wifi；此时iOS系统会弹出警告窗口“无法加入网络“MINIEYE-””。
//                        completion(false,NEHotspotConnectError.configureSuccessNotConnect)
//                        print_Debug(message: "wifi配置成功，但是没有直接连上,wifiConnectLock=\(wifiConnectLock)")
//                    }
//                }
//                configureWifiCompleted = true
//                wifiConnectLock.unlock()
//            }
//        }else {
//            completion(false,NEHotspotConnectError.systemVersionTooLow)
//        }
//    }
//
//}
//
////MARK: - monitor network state -
//extension HTTPNetworkTool {
//
//    typealias ConnectionType = NetworkReachabilityManager.ConnectionType
//    ///单元测试完成
//    /// 检车某个域名是否可连接，不可用来检测我司设备wifi是否可连接。因为我司的deviceHostName是iP地址，蜂窝网络和wifi连接万维网时认为该IP是可连接的。
//    /// - Parameters:
//    ///   - hostName: 域名，不得包含协议以及文件地址等
//    ///   - completion: 回调，第一个返回该域名是否可连接，第二个返回连接方式是wwan还是wifi
//    func isConnectToServer(hostName:String = MEHost.cloudHostName,completion:@escaping (_ isConnected:Bool,_ type:ConnectionType?)->()){
//        HTTPNetworkTool.shared.checkNetworkStatusAndWifiSSid(hostName:hostName,isNeedSSid: false) { (status, ssid, error) in
//            if case .reachable(let type) = status {
//                completion(true,type)
//            } else {
//                completion(false,nil)
//            }
//        }
//    }
//
//    ///已单元测试完成。
//    /// 检查某个域名hostname的网络连接状态；如果是可连接的，而且需要获取ssid，并且当前网络是WiFi连接，就递归获取SSID；回调网络连接状态以及可能存在的ssid，错误信息等
//    /// 连接了我司设备wifi后，连接时是先判断是否可以通过wifi连接；如果不行，会转到wwan；所以会判断两次，设备wifi和wwan。
//    /// - Parameters:
//    ///   - hostName: 需要检查网络状态的域名
//    ///   - isNeedSSid: 是否需要SSID
//    ///   - completion: 完成回调，如果是WIFI状态下，会连续多次请求获取WiFiSSid。新的iOS11的系统，可能会出现SSID一直拿不到的问题（系统BUG）;Error只有获取wifi拿不到会出现，一个是授权地理位置信息失败的错误
//    func checkNetworkStatusAndWifiSSid(hostName:String? = MEHost.deviceHostName,isNeedSSid:Bool = true,completion:@escaping (_ netWorkStatus:NetworkReachabilityManager.NetworkReachabilityStatus,_ wifiName:String?,_ error:Error?)->()) {
//
//        var networkReachablityManager:NetworkReachabilityManager?
//
//        if  let hostName = hostName{
//            networkReachablityManager = NetworkReachabilityManager.init(host: hostName)
//        }else {
//            networkReachablityManager = NetworkReachabilityManager.init()
//        }
//        if let networkReachablityManager = networkReachablityManager {
//            print_Debug(message: "networkReachablityManager hostName=\(String(describing: hostName)),networkReachablityManager.networkReachabilityStatus=\(networkReachablityManager.networkReachabilityStatus)")
//            switch networkReachablityManager.networkReachabilityStatus {
//            case .notReachable:
//                completion(.notReachable,nil,nil)
//            case .unknown:
//                completion(.unknown,nil,nil)
//            case .reachable(.ethernetOrWiFi):
//                if isNeedSSid {
//                    authorizeAndPollingToGetCurrentWifiSSID { (ssid, error) in
//                        completion(.reachable(.ethernetOrWiFi),ssid,error)
//                    }
//                } else {
//                    completion(.reachable(.ethernetOrWiFi),nil,nil)
//                }
//            case .reachable(.wwan):
//                completion (.reachable(.wwan),nil,nil)
//            }
//
//        }else {
//            fatalError("networkReachablityManager is nil")
//        }
//    }
//
//    ///单元测试完成；
//    /// 监听某个hostName对应的网络连接状态改变，可以是iP地址，域名地址等，状态改变时回调会执行多次，并同时发出通知。
//    /// 不同hostName的回调情形完全不一致，建议配合isConnectToServer使用。
//    /// 1.hostName 为nil时，域名采用默认的0.0.0.0
//    /// 2.域名IP为0.0.0.0和cloudHostName的结果相同：
//    ///（a）设备服务器Wifi不识别该域名，如果连接设备wifi，系统会认为notReachable；然后如果此时连接了有wwan，会使用wwan的连接状态isReachableWWan；（b）如果连接的是公司wifi，状态是isReachableWifi。（c）如果有wwan，会是isReachableWWan
//    /// 3.deviceHostName是设备wifi、网络wifi、wwan全部isReachabele的。当存在wifi时，优先显示isReachableWifi，无wifi有4G时是isReachableWWan，都没有才是notReachable。
//    /// 4.如果isReachable类型改变了，或者从isReachable到notReachable之间切换，就会出现
//    /// - Parameters:
//    ///   - hostName: 域名，可以是ip地址或者网络地址，不得带协议前缀和访问地址
//    ///   - completion: 监听网络改变之后的回调，会在网络改变之后回调。注意，当某个域名的连接状态没有改变时不会回调。例如，使用cloudHostName连接了公司一个wifi，切换到另一个公司wifi，不会通知。
//    func monitorNetworkChangedAndPostNotification(hostName:String? = nil, _ completion:@escaping (_ status:NetworkReachabilityManager)->()) -> () {
//
//        var networkReachablityManager = NetworkReachabilityManager.init()
//
//        if  let hostName = hostName{
//            if reachablityManagers.contains(where: { $0.key == hostName }) {
//                networkReachablityManager = reachablityManagers[hostName]
//            }else {
//                networkReachablityManager = NetworkReachabilityManager.init(host: hostName)
//                reachablityManagers[hostName] = networkReachablityManager!
//            }
//            networkReachablityManager?.hostName = hostName
//        }
//
//        if networkReachablityManager?.startListening() ?? false {
//            networkReachablityManager?.listener = { [unowned self] (status) in
//                print_Debug(message: "wifi changed, net work status changed =\(status)，hostName=\(String(describing: hostName))")
//                completion(networkReachablityManager!)
//                NotificationCenter.default.post(name: NSNotification.Name.Network.connectChanged, object:networkReachablityManager)
//
//            }
//            print_Debug(message: "start monitor network status，hostName=\(String(describing: hostName))")
//        }
//    }
//
//}
//
//extension NetworkReachabilityManager {
//
//    static var hostNameKey = "hostNameKey"
//
//    var hostName:String? {
//        set {
//            objc_setAssociatedObject(self, &NetworkReachabilityManager.hostNameKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//        get {
//            return objc_getAssociatedObject(self, &NetworkReachabilityManager.hostNameKey) as? String
//        }
//    }
//}
//
//extension Notification.Name {
//    struct Network {
//        static let connectChanged = Notification.Name.init("网络状态改变了")
//    }
//}
//
//
//class WifiMonitor {
//    let networkChangeNotiName:String = kNotifySCNetworkChange
//    static let WifiChangedNotiName = Notification.Name.init("com.minieye.WifiChangedNotificationName")
//    static var shared:WifiMonitor = {
//        let monitor = WifiMonitor()
//        monitor.startMonitorWifi()
//        return monitor
//    }()
//
//
//    func startMonitorWifi() {
//        let monitorCallback:CFNotificationCallback = {(center, observer, name, objectPtr, userinfo) in
//            if let tName = name?.rawValue,
//                (tName as String) == "com.apple.system.config.network_change" {
////                let ssid = HTTPNetworkTool.shared.getSystemWifiSSID()
////                print_Debug(message: "wifi changed -ssid " + "\(ssid ?? "can not get wifi ssid")")
////                WifiMonitor.shared.currentWifiSSID = ssid
//                print_Debug(message: "wifi changed,center=\(center),observer=\(observer),name=\(name),objectPtr=\(objectPtr),userinfo=\(userinfo)")
//                NotificationCenter.default.post(name: WifiMonitor.WifiChangedNotiName,
//                                                object: nil,
//                                                userInfo: nil)
//            }
//        }
//        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
//                                        nil,
//                                        monitorCallback,
//                                        (networkChangeNotiName as CFString),
//                                        nil,
//                                        CFNotificationSuspensionBehavior.deliverImmediately)
//    }
//
//    deinit {
//        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
//                                           nil,
//                                           CFNotificationName.init(networkChangeNotiName as CFString),
//                                           nil)
//    }
//}
//
//
//extension HTTPNetworkTool {
//
//    func c8UploadFileBinary(path:String,
//                            file:URL,
//                            uploadRequest:((_ request:UploadRequest) -> Void)? = nil,
//                            uploadProgress:((_ progress:Progress) -> Void)? = nil,
//                            complete:NetworkCompletion?) {
//        let request = Alamofire.upload(file, to: MEHost.deviceC8Host + path)
//        uploadRequest.map{$0(request)}
//        request.uploadProgress { (progress) in
//            uploadProgress.map{$0(progress)}
//        }
//        request.responseJSON { response in
//            self.handleC8ResponseJson(response: response, jsonComplete: complete)
//        }
//    }
//
//
//    @discardableResult
//    func c8Request(path:String,
//                   method:HTTPMethod = .get,
//                   timeout:TimeInterval = 10,
//                   encoding:ParameterEncoding = URLEncoding.default,
//                   parameters:[String:Any]? = nil,
//                   with jsonComplete:NetworkCompletion?) -> DataRequest? {
//
//        var originalRequest = URLRequest.init(url: URL.init(string: MEHost.deviceC8Host + path)!,
//                                              cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
//                                              timeoutInterval: timeout)
//        let encodedURLRequest:URLRequest
//
//        originalRequest.httpMethod = method.rawValue
//
//        do {
//            encodedURLRequest = try encoding.encode(originalRequest, with: parameters)
//        } catch {
//            jsonComplete.map{$0(nil,error as! AFError, nil)}
//            return nil
//        }
//
//        let afRequest = HTTPNetworkTool.shared.sessionManager.request(encodedURLRequest)
//        afRequest.responseJSON { (resp) in
//            self.handleC8ResponseJson(parameters: parameters, response: resp, jsonComplete: jsonComplete)
//        }
//        return afRequest
//    }
//
//
//    func handleC8ResponseJson(parameters:[String:Any]? = nil,response:DataResponse<Any>,jsonComplete:NetworkCompletion?){
//        if let resp = response.response {
//            print_Debug(message: "c8 responseJSON has response resp.statusCode \(resp.statusCode) \n resp.request.url \(String(describing: response.request?.url))")
//        }
//        if response.error != nil || response.value == nil || response.data == nil {
//            let error = response.error
//            print_Debug(message: "c8 responseJSON has error, request \(String(describing: response.request))\n error=\(String(describing: error)), resp.data=\(String.init(data: response.data!.prefix(1000), encoding: .utf8) ?? "nil")")
//                if let nsError = error as? CFNetworkErrors {
//                    jsonComplete.map({ $0(nil,nsError,nil) })
//                }else if let urlError = error as? URLError {
//                    jsonComplete.map({ $0(nil,urlError,nil) })
//                }else if let afnError = error as? AFError {
//                    jsonComplete.map({ $0(nil,afnError,nil) })
//                }else {
//                    jsonComplete.map({ $0(nil,NetworkServiceError.thirdPartyUnkownError(error: error),nil) })
//                }
//        } else {
//            let responseValue = response.value
//            if let json = responseValue as? [String:Any]
////                ,let code = json["code"] as? Int
//            {
//                print_Debug(message: "c8 responseJSON is json, responseValue=\(json.descriptionWithCountLimit(1000))")
////                if code == 200 {
//                    jsonComplete.map({ $0(json,nil,response) })
////                } else {
////                        jsonComplete.map({ $0(json,NetworkServiceError.other(code:code, message: json["error"] as? String),response)})
////                }
//            } else {
//                print_Debug(message: "c8 responseJSON is not json, responseValue=\(String(describing: responseValue))")
//                if responseValue == nil {
//                    jsonComplete.map({ $0(nil,NetworkServiceError.responseEmpty,response)})
//                }else {
//                    jsonComplete.map({ $0(nil,NetworkServiceError.decodeResponseStringFailure(statusCode:response.response?.statusCode),response)})
//                }
//            }
//        }
//        print_Debug(message:"responseJSON complete")
//
//    }
//
//
//}
