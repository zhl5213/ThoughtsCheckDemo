//
//  NSObject+Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/11/18.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation


func excuteSyncSafeOnMainThread(block:@escaping ()->()) -> () {
    
    if Thread.current == Thread.main {
        block()
    }else{
        DispatchQueue.main.sync {
            block()
        }
    }

}
