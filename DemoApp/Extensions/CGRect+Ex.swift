
//
//  CGRect+Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/23.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation


extension CGRect {
    
    enum property {
        case width
        case height
        case x
        case y
    }
    
    
    func updateProperty(_ property:property,value:CGFloat,editType:EditType = .add) -> CGRect {
        
        var x = origin.x
        var y = origin.y
        var newWidth = width
        var newHeight = height
        switch editType {
        case .add:
            switch property {
            case .width:
                newWidth += value
            case .height:
                newHeight += value
            case .x:
                x += value
            case .y:
                y += value
            }
        case .replace:
            switch property {
            case .x:
                x = value
            case .y:
                y = value
            case .width:
                newWidth = value
            case .height:
                newHeight = value
            }
        case .delete:
            fatalError("edit type wrong")
        }        
        
        return CGRect.init(x: x, y: y, width: newWidth, height: newHeight)
    }
    
    func x() -> CGFloat {
        return origin.x
    }
    
    func y() -> CGFloat {
        return origin.y
    }
 
    
}

extension CGSize {
    
    enum property {
        case width
        case height
    }
    
    func updateProperty(_ addProperty:property,value:CGFloat,editType:EditType = .add) -> CGSize {
        
        var newWidth = width
        var newHeight = height
                
        switch editType {
        case .add:
             switch addProperty {
             case .width:
                 newWidth += value
             case .height:
                 newHeight += value
             }
        case .replace:
            switch addProperty {
            case .width:
                newWidth = value
            case .height:
                newHeight = value
            }
        case .delete:
            fatalError("edit type wrong")
        }
        
        
        return CGSize.init(width: newWidth, height: newHeight)
    }
    
    
}
