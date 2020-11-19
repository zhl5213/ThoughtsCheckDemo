//
//  RoundRectButton.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/31.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

class RoundRectButton: BasicButton {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let originSize = super.sizeThatFits(size)
        
        return CGSize.init(width: originSize.width + 10, height: originSize.height)
    }
    
    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: 5, y: 0, width: bounds.width - 10, height: bounds.height)
    }
    

}
