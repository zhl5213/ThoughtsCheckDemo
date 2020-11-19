//
//  Dictionary.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/7/26.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation


extension Dictionary {
    
    func toJsonString() -> String {
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options:JSONSerialization.WritingOptions.prettyPrinted) {
            return  String.init(data: data, encoding: String.Encoding.utf8) ?? ""
        }else{
            return ""
        }
    }
    
}

extension Array where Element == [String:Any] {
    
    func toJsonString() -> String {
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return  String.init(data: data, encoding: String.Encoding.utf8) ?? ""
        }else {
            return ""
        }
        
    }
    
}


extension NSMutableDictionary {
//   remove to remain only instances of NSData, NSDate, NSNumber, NSString, NSArray, or NSDictionary
     func removeUnPropertyElement() {
        for (key,value) in self {
             switch value {
               case let array as NSArray:
                let newArray = NSMutableArray.init(array: array)
                newArray.removeUnPropertyElement()
                self.setValue(newArray, forKey: key as! String)
//                   print("array =\(array),newArray =\(newArray)")
               case let dict as NSDictionary:
                let newDict = NSMutableDictionary.init(dictionary: dict)
                newDict.removeUnPropertyElement()
                self.setValue(newDict, forKey: key as! String)
//                   print("dict =\(dict),newDict=\(newDict)")
             case _ as NSData:
//                   print("data =\(data)")
                break
             case _ as NSDate:
//                   print("date =\(date)")
                break
             case _ as NSNumber:
//                   print("number =\(number)")
                break
             case _ as NSString:
//                   print("string =\(string)")
                break
               default:
//                   print("other type value =\(value)")
                   self.removeObject(forKey: key)
               }
//            print("after remove key =\(key),value=\(String(describing:self[key]))")
        }

    }
}

extension NSMutableArray {
    //   remove to remain only instances of NSData, NSDate, NSNumber, NSString, NSArray, or NSDictionary
     func removeUnPropertyElement() {
        
        for index in (0..<self.count).reversed() {
            let element = self[index]
            
            switch element {
           case let array as NSArray:
             let newArray = NSMutableArray.init(array: array)
             newArray.removeUnPropertyElement()
             self.replaceObject(at: index, with: newArray)
//                print("array =\(array),newArray =\(newArray)")
            case let dict as NSDictionary:
             let newDict = NSMutableDictionary.init(dictionary: dict)
             newDict.removeUnPropertyElement()
             self.replaceObject(at: index, with: newDict)
//                print("dict =\(dict),newDict=\(newDict)")
            case _ as NSData:
//                print("data =\(data)")
             break
            case _ as NSDate:
//                print("date =\(date)")
             break
            case _ as NSNumber:
//                print("number =\(number)")
             break
            case _ as NSString:
//                print("string =\(string)")
             break
            default:
//                print("other type element =\(element)")
                self.removeObject(at: index)
            }
        }
    }
}
