//
//  CacheManager.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/16.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

class DataPersistenceTool: BasicTool {
    
    static let shared = DataPersistenceTool()
    private let defaults = UserDefaults.standard
    private lazy var sdImageCache:SDImageCache = {
        let config = SDImageCacheConfig.init()
        config.shouldCacheImagesInMemory = false
        let cache = SDImageCache.init(namespace: "cc.minieye.www",diskCacheDirectory: nil,config: config)
        return cache
    }()
    
    // 已废弃
    func fetchObjectFromPerference(objectType:NSObject.Type) -> NSObject {
        
        let object = objectType.init()
        
        let placeMirror = Mirror.init(reflecting: object)
        
        for case (let originName,_) in placeMirror.children {
            let storeName = String.init(describing: type(of: object).self) + "." +  originName!
            let cacheValue = defaults.object(forKey: storeName)
//            print_Debug(message: "fetch from perference  originName=%@,storeName=\(storeName),cacheValue=\(String(describing: cacheValue))\n")
            
            switch cacheValue {
            case Optional<Any>.none:
                print("originValue=\(String(describing: cacheValue))")
            default:
                object.setValue(cacheValue, forKey: originName!)
                print("originValue != nil.originValue=\(String(describing: cacheValue))")
                
            }
        }
        
        return object
    }
    
// 已废弃
    func set(objectIntoPerference object:NSObject) -> () {
        
        let placeMirror = Mirror.init(reflecting: object)
        
        for case  (let originName,let originValue) in placeMirror.children {
            let storeName = String.init(describing: type(of: object).self) + "." +  originName!
            print_Debug(message:"store in perference originName=\(originName!),storeName=\(storeName),originValue=\(originValue)\n")
            
            switch originValue {
            case Optional<Any>.none:
                print("originValue=\(originValue)")
            default:
                defaults.setValue(originValue, forKey: storeName)
                print("originValue != nil.originValue=\(originValue)")
                
            }
        }
    }

    // 已废弃
    func fetchFromDataBase(dataKey:String) -> Any {
        return ""
    }
    
}

extension DataPersistenceTool {
    
    func clearMemory() -> () {
        sdImageCache.clearMemory()
    }
    
    // 已测试，
    func imageExistInDiskFor(key:String) -> Bool {
        return sdImageCache.diskImageDataExists(withKey: key)
    }
    
    // 已测试，
    func imageFromDiskCacheFor(key:String) -> UIImage? {
        return sdImageCache.imageFromDiskCache(forKey: key)
    }
    
    // 已测试，
/// 保存image到磁盘空间，该过程极为耗时，测试回调长的时候有1秒，所以要异步执行；
    ///经过多轮测试，自己绘制的1000X800以及以上分辨率的图片无法保存到disk中；
    func storeImageToDisk(_ image:UIImage? = nil,imageData:Data? = nil,forKey key:String,completion:(()->())?) {
        sdImageCache.store(image, imageData: imageData, forKey: key, toDisk: true, completion: completion)
    }
    
    // 已测试，
    func removeImageFromDiskFor(key:String) -> () {
        sdImageCache.removeImageFromDisk(forKey: key)
    }
    
    // 已测试，
    func imageFromMemoryFor(key:String) -> UIImage? {
        return sdImageCache.imageFromMemoryCache(forKey: key)
    }
    
    /// 保存是异步的，执行store之后，立即调用无法拿到;
    /// 已测试，测试结果是需要0.02秒之后拿到
    /// - Parameters:
    ///   - image: 任意图片
    ///   - key: 标识图片的唯一标识符
    func storeImage(inMemory image:UIImage, for key:String) -> () {
        sdImageCache.storeImage(toMemory: image, forKey: key)
    }
    
    // 已测试，
    func removeImageFromMemoryFor(key:String) -> () {
        sdImageCache.removeImageFromMemory(forKey: key)
    }
    
}


extension UIImage {
    
    static func imageFromMemoryFor(key:String) -> UIImage? {
        return DataPersistenceTool.shared.imageFromMemoryFor(key: key)
    }
    
    static func imageDiskFor(key:String) -> UIImage? {
        return DataPersistenceTool.shared.imageFromDiskCacheFor(key: key)
    }
    
}
