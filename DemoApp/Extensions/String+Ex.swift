//
//  String+Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/20.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation

//extension String{
//    
//    func localizedString(with comment:String = "") -> String {
//        return NSLocalizedString(self, comment: comment)
//    }
//    
//}


extension String {
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(from16, within: self) else { return nil }
        guard let toIndex = String.Index(to16, within: self) else { return nil }
        //        直接崩溃，显示fromIndex是UInt64数字 131328;toIndex是65792；
//        let fromIndex = index(startIndex, offsetBy: range.location, limitedBy: endIndex)
//        let toIndex = index(startIndex, offsetBy: range.length, limitedBy: endIndex)
        return fromIndex..<toIndex
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    func indexMoveAfter(_ count:Int) -> String.Index? {
        return index(startIndex, offsetBy: count, limitedBy: endIndex)
    }
    
}


extension String {
    
    
    func hasNoContent() -> Bool {
        let afterRemoveSpacingString = replacingOccurrences(of: " ", with: "")
        return afterRemoveSpacingString.count == 0
    }
}


extension String {
    
    func toDictionary() -> [String:Any]? {
        guard count > 0 else {
            return nil
        }
        
        if let data = data(using: String.Encoding.utf8), let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]{
            return dic
        }else{
            return nil
        }
        
    }
    
}
