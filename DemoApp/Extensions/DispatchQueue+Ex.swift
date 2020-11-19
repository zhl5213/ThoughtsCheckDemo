//
//  DispatchQueue+Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/6/11.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation


extension DispatchQueue {
    
    private static var tokenContainer:[String] = [String]()
    
    public class func once(token:String,block:()->()) -> () {
        
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if tokenContainer.contains(token) {
            return
        }
        
        tokenContainer.append(token)
        block()
    }
    
}
