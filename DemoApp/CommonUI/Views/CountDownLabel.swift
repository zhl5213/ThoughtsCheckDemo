//
//  CountDownLabel.swift
//  MiniEye
//
//  Created by user_ on 2019/7/7.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

class CountDownLabel: BasicLabel {
    
    let codeTimeInterval:Int = UserAccountManager.SMCodeTimeInterval
    var codeTime:Int = 0
    var codeTimer:Timer?
    var countDownText: String = ""
    var completion:((_ label:CountDownLabel) -> ())? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.stopCount()
    }
    
    func startCount(with block:((_ label:CountDownLabel)->())?) {
        self.startCount()
        if let _ = block {
            block!(self)
        }
    }
    
    func startCount() {
        self.codeTime = codeTimeInterval
        self.codeTimer = Timer.init(timeInterval: 1, target: self, selector: #selector(codeTimerAction), userInfo: nil, repeats: true)
        self.codeTimer!.fireDate = Date.init()
        self.codeTimer!.fire()
        self.isHidden = false
        RunLoop.current.add(self.codeTimer!, forMode: .common)
    }
    
    func stopCount() {
        self.codeTimer?.invalidate()
        self.codeTime = codeTimeInterval
        if let _ = self.completion {
            self.completion!(self)
        }
    }
    
    @objc func codeTimerAction() {
        if self.codeTime > 0 {
            self.text = String.localizedStringWithFormat(self.countDownText, self.codeTime)
            self.codeTime -= 1
        } else {
            stopCount()
        }
    }
    
}
