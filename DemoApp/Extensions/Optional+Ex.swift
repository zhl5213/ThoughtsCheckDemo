//
//  Optional+Ex.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/29.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    func wrappedToString() -> String {
        if let trValue = self {
            return trValue
        }else{
            return ""
        }
    }
}



protocol OptionalType {
    
    associatedtype wrappedValue
    var optional:wrappedValue? {get}
    
}

extension Optional:OptionalType {
    
    typealias wrappedValue = Wrapped
    
    var optional:wrappedValue? {return self}
}


extension Array where Element : OptionalType {
    
    func unWrapped() -> [Element.wrappedValue]? {
        
        return reduce(Optional<[Element.wrappedValue]>([])) { result, element in
            result.flatMap { optionalArry in element.optional.map { optionalArry + [$0] } }
        }
    }
}
