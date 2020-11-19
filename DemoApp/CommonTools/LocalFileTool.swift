////
////  LocalFileManager.swift
////  MiniEye
////
////  Created by 朱慧林 on 2019/5/16.
////  Copyright © 2019 MINIEYE. All rights reserved.
////
//
//import UIKit
//
//
//
//protocol LocalStorable {}
//extension Dictionary:LocalStorable{}
//extension Data:LocalStorable{}
//
//enum FileError:String,CodedError {
//    case canNotEnumerator = "文件查找失败"
//    case getFileContentFailed = "获取文件内容失败"
//    case writeToFileFailed = "写入文件失败"
//    case fileNotExsit = "文件不存在"
//
//    enum CreateDirctory:String,CodedError {
//        case DirectoryAlreadyExsit = "文件已存在"
//        case isNotFileUrl = "不是文件夹"
//        case createFailed = "创建失败"
//    }
//
//    var localizedDescription: String {return self.rawValue}
//}
//
//class LocalFileTool: BasicTool {
//
//    struct FilePath {
//        static let needCreatePaths = [compositeVedioDir,interceptVedioDir,feedbackVideo,myDeviceListDir,firmware,systemFirmware,upgradeLogs,albumDownloadMediasDir,databaseURL]
//
//        static let libaryCacheRoot = URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
//         static let documentRoot =  URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
//
//        static let interceptVedioDir = libaryCacheRoot.appendingPathComponent("interceptVedio",isDirectory: true)
//        static let compositeVedioDir = libaryCacheRoot.appendingPathComponent("compositeVedios",isDirectory: true)
//
//        static let myDeviceListDir = documentRoot.appendingPathComponent("myDeviceList",isDirectory: true)
//        static let autoDownloadMediasDir = documentRoot.appendingPathComponent("autoDownloadMedias",isDirectory: true)
//        static let albumDownloadMediasDir = documentRoot.appendingPathComponent("albumDownloadMedias",isDirectory: true)
//        static let feedbackVideo = libaryCacheRoot.appendingPathComponent("feedbackVideo")
//        static let diagnosticDownloadDir = libaryCacheRoot.appendingPathComponent("diagnosticDownload",isDirectory: true)
//
//        static let firmware = documentRoot.appendingPathComponent("firmware")
//        static let systemFirmware = documentRoot.appendingPathComponent("systemFirmware")
//        static let upgradeLogs = documentRoot.appendingPathComponent("upgradeLogs")
//        static let databaseURL = documentRoot.appendingPathComponent("databaseURL",isDirectory: true)
//    }
//
//    struct FileNamePrefix {
//        static let myDeviceList = "MyDevice_"
//        static let autoDownloadMedias = "autoDownload_"
//        static let albumDownloadMedias = "albumDownload_"
//    }
//
//    static let shared = LocalFileTool.init()
//
/////创建需要初始化的文件夹，包括视频合成文件夹、视频截取文件夹、反馈文件夹、我的设备列表文件夹、固件文件夹、升级日志文件夹、
//    func initTool() -> () {
//        createLocalDirectorys(urls: FilePath.needCreatePaths)
//    }
//
//    ///测试完成
//    /// 根据URL数组创建文件夹，如果数组中URL本身存在就不创建;如果不是文件url就不创建；返回值是对应的URL是否是全新创建的；会创建所有的中间文件夹；
//    @discardableResult
//    func createLocalDirectorys(urls urlPaths:[URL]) -> [(success:Bool,error:FileError.CreateDirctory?)] {
//        var create = [(success:Bool,error:FileError.CreateDirctory?)]()
//
//        for url in urlPaths {
//            if FileManager.default.fileExists(atPath: url.path) {
//                create.append((false,FileError.CreateDirctory.DirectoryAlreadyExsit))
//            }else if url.isFileURL == false {
//                create.append((false,FileError.CreateDirctory.isNotFileUrl))
//            }else {
//                do {
//                   try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
////                    print_Debug(message: "try create Path =\(url)")
//                } catch {
//                    create.append((false,.createFailed))
////                    print_Debug(message: "create Path =\(url) failed,error=\(error)")
//                    continue
//                }
////                print_Debug(message: "create Path =\(url) success")
//                create.append((true,nil))
//            }
//        }
//        return create
//    }
//
////测试完成
/////  删除url文件夹下面符合某个策略的所有文件：
/////fileNamePolicy 是文件名称过滤器；如果是文件夹的时候，过滤文件夹下面的文件名称；如果是单个文件，就过滤文件的名称；
//    func deleteFilesIn(localDirectory url:URL,fileNamePolicy:((_ fileName:String)->Bool)? = nil,completion:((_ deletedFileNames:[String])->())? = nil) -> () {
//
//        var fileNames = [String] ()
//
//        func deleteFileWith(name:String,fileUrl:URL)  {
//
//            if let tfileNamePolicy = fileNamePolicy,tfileNamePolicy(name){
//                do {
//                    fileNames.append(name)
//                    try FileManager.default.removeItem(at: fileUrl)
////                    print_Debug(message: "deleteFiles fileUrl = \(fileUrl) success")
//                }catch {
//                    fileNames.removeLast()
////                    print_Debug(message: "deleteFiles fileUrl = \(name) failed ,error = \(error.localizedDescription)")
//                }
//            }
//        }
//
//        if FileManager.default.fileExists(atPath: url.path) {
//            if url.hasDirectoryPath {
//                if  let fileEnumerator = FileManager.default.enumerator(atPath: url.path) {
//                    for file in fileEnumerator {
//
//                        if let fileName = file as? String {
//                            let fileUrl = URL.init(fileURLWithPath: url.path).appendingPathComponent(fileName)
//                            deleteFileWith(name: fileName, fileUrl: fileUrl)
//                        }
//                    }
//                }
//                completion?(fileNames)
//            }else {
//                let fileName = url.lastPathComponent
//                deleteFileWith(name: fileName, fileUrl: url)
//                completion?(fileNames)
////                print_Debug(message: "deleteFile at url = \(url) completed ,it's not a directory")
//            }
//        }else{
//            completion?(fileNames)
////            print_Debug(message: "delete file not exsit url=\(url)")
//        }
//    }
//
//    ///已测试
/////  批量获取本地文件夹下面的文件（注意at是本地，type是该文件夹下面的数据类型，暂时只实现了dictionary和data）；
//    ///  如果url是文件夹，就将文件夹下面的所有可以转化为格式的文件转化为该格式；如果url是个具体文件地址，就尝试将该文件转为该格式；（注意，所有的文件都可以转化为data格式，所以data是返回所有的文件）
//    func files(at localUrl:URL,type:LocalStorable.Type,fileNamePolicy:((_ fileName:String)->Bool)? = nil,complete:CommonCompleteBlock) -> () {
//
//        guard FileManager.default.fileExists(atPath: localUrl.path) else {
//            complete(false,FileError.fileNotExsit,nil)
//            return
//        }
//        var fileArray = [LocalStorable]()
//        var noContentFileName = ""
//
//        if localUrl.hasDirectoryPath {
//
//            if let fileEmunator = FileManager.default.enumerator(atPath: localUrl.path) {
//
//                for file in fileEmunator {
//
//                    if let fileName = file as? String,
//                        //                    fileName.hasPrefix(FilePrefix.myDeviceList),
//                        let fileUrl =  URL.init(string: fileName, relativeTo: localUrl) {
//
//                        if let tfileNamePolicy = fileNamePolicy {
//                            if tfileNamePolicy(fileName) ==  false  { continue }
//                        }
//
//                        if type == [String:Any].self {
//                            if let dicInfo = NSDictionary.init(contentsOf:fileUrl) as? [String:Any] {
//                                fileArray.append(dicInfo)
//                            }else {
//                                noContentFileName +=  (noContentFileName.count > 0) ?  ("、" +  fileName ) : fileName
//                            }
//                        }else if type == Data.self{
//                            if fileUrl.pathExtension == "", let data = try? Data.init(contentsOf: fileUrl){
//                                fileArray.append(data)
//                            }else {
//                                noContentFileName +=  (noContentFileName.count > 0) ?  ("、" +  fileName ) : fileName
//                            }
//                        }
//                        //else if type == String.self, let str = try? String.init(contentsOf: fileUrl) {
//                        //TODO: 字符串类型数据的处理
//                        //}else if type == Array<Any>.self, let array = NSArray.init(contentsOf: fileUrl) as? Array<Any> {
//                        //TODO: Array数据的处理
//                        //}
//                    }else{
//                        fatalError("file name \(file) is not string")
//                    }
//                }
//
//            complete(true,nil,fileArray)
//
//            }else{
//                complete(false,FileError.canNotEnumerator,nil)
//            }
//
//        }else {
//            let fileName = localUrl.lastPathComponent
//
//            if let tfileNamePolicy = fileNamePolicy {
//                if tfileNamePolicy(fileName) ==  false  { return }
//            }
//
//            if type == [String:Any].self {
//                if let dicInfo = NSDictionary.init(contentsOf:localUrl) as? [String:Any] {
//                    fileArray.append(dicInfo)
//                }else {
//                    noContentFileName +=  (noContentFileName.count > 0) ?  ("、" +  fileName ) : fileName
//                }
//            }else if type == Data.self{
//                if let data = try? Data.init(contentsOf: localUrl){
//                    fileArray.append(data)
//                }else {
//                    noContentFileName +=  (noContentFileName.count > 0) ?  ("、" +  fileName ) : fileName
//                }
//            }
//
//            if noContentFileName.count > 0 {
//                complete(false,FileError.getFileContentFailed,nil)
//            }else{
//                complete(true,nil,fileArray)
//            }
//
//        }
//
//    }
//
//
//    ///已测试
//    /// 在指定的文件夹中批量按照names储存对应的contents内容；注意at后面的参数可以是文件夹或者具体的文件路径，names是存储的内容的名字；
/////如果url中有对应名字的文件，会删除原文件，然后存储新文件；批量存储如果有一个没有成功，complete回调中参数就是失败，data返回存储失败的文件名字；方法不会检查url文件夹车是否存在
//    /// - complete :第一个参数是代表是否存储成功，所有数据全部保存成功返回true，否则返回false；
//    /// - :    第二个参数是错误信息，第一个参数是false时存在，否则为nil；第三个参数是第一个参数是false的时候存储失败设备名字数组，成功的时候返回nil；
//    func store(at directory:URL,namesAndContents:[String:LocalStorable],complete:CommonCompleteBlock) -> () {
////        if names.count != contents.count { fatalError( "存储信息名字和内容数量不一致" )}
//
//        var unstoreNames = [String]()
//
//        for (name,content) in namesAndContents {
//
//            let fileUrl  = directory.appendingPathComponent(name, isDirectory: false)
//            var deleteSuccess = true
//
//            do {
//                try FileManager.default.removeItem(at: fileUrl)
//            } catch let deleteError {
//                deleteSuccess = false
////                print_Debug(message: "before store at dirctory, delete fileUrl=\(fileUrl) failed,deleteError=\(deleteError)")
//            }
//            if deleteSuccess {
////                print_Debug(message: "before store at dirctory, delete fileUrl=\(fileUrl) success")
//            }
//
//
//            if  let dict = content as? Dictionary<String,Any>{
//                let mutaDic = NSMutableDictionary.init(dictionary: dict)
//                    mutaDic.removeUnPropertyElement()
//                if mutaDic.write(toFile: fileUrl.path, atomically: true) == false {
//                    unstoreNames.append(name)
//                }
//            }else if let data = content as? Data {
//                if  let _ = try? data.write(to: fileUrl, options: Data.WritingOptions.completeFileProtection) {
//
//                }else{
//                    unstoreNames.append(name)
//                }
//            }
////            else if let array = content as? Array<Any> {
////                (array as NSArray).write(toFile: fileUrl.path, atomically: true)
////            }
//        }
//
//        if unstoreNames.count > 0 {
//            complete(false,FileError.writeToFileFailed,unstoreNames)
//        }else {
//            complete(true,nil,nil)
//        }
//
//    }
//
//
//
//    func fetchInfoInBundle(fromPlist name:String) -> NSDictionary? {
//        let plist = Bundle.main.path(forResource: name, ofType:"plist" )
//        return NSDictionary.init(contentsOfFile: plist ?? "")
//    }
//
//
//
//}
//
//
