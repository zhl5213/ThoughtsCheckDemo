//
//  ProgressButton.swift
//  MiniEye
//
//  Created by user_ on 2019/8/23.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

class ProgressButton: BasicButton {
    let progressColor = UIColor.colorWithHex(hex: 0x4E77ED, alpha: 0.4)
    let borderColor = UIColor.colorWithHex(hex: 0x4E77ED, alpha:1)
    let titleColor = UIColor.colorWithHex(hex: 0x4E77ED)
    
    private let animationKey = "animation.shimmer"
    enum Status {
        case normal
        case progress
        case waiting
    }
    
    var buttonStatus:Status = .normal {
        didSet {
            self.progressLayer.isHidden = self.buttonStatus == .normal
//            if self.buttonStatus == .waiting {
//                addMask()
//            } else {
//                clearMask()
//            }
        }
    }
    
    var progress:Double = 0 {
        didSet {
            updateProgress()
        }
    }
    
    func updateProgress() {
        var frame = self.bounds
//        UIView.beginAnimations(nil, context: nil)
        frame.size.width = CGFloat(self.progress *  Double(frame.width))
        self.progressLayer.frame = frame
//        UIView.commitAnimations()
    }
    
    // shimmer
    func clearMask() {
        if self.titleLabel?.layer.mask == shimmerLayer {
             self.titleLabel?.layer.mask = nil
        }
    }
    
    func addMask() {
        if self.titleLabel?.layer.mask == nil {
             self.titleLabel?.layer.mask = shimmerLayer
        }
    }
    
    var shimmerLayer:CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.anchorPoint = CGPoint.zero
        layer.position = CGPoint.zero
        let maskedColor = UIColor.init(white: 1.0, alpha: 1.0)
        let unmaskedColor = UIColor.init(white: 1.0, alpha: 0.3)
        layer.colors = [unmaskedColor.cgColor,maskedColor.cgColor,unmaskedColor.cgColor]
        layer.startPoint = CGPoint.init(x: 0, y: 0.5)
        layer.endPoint = CGPoint.init(x: 1, y: 0.5)
        layer.locations = [0.25,0.5,0.75]

        return layer
    }()
    
    func animation(duration:CFTimeInterval) -> CABasicAnimation {

        let animation = CABasicAnimation.init(keyPath: "position")
        animation.delegate = self
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        animation.duration = duration
        animation.toValue = CGPoint.zero
        return animation
    }
        
    func updateMask() {
        let contentFrame = titleLabel?.bounds ?? CGRect.zero
        let frame = contentFrame.insetBy(dx: -contentFrame.width , dy: 0)
        shimmerLayer.frame = frame
        shimmerLayer.position = CGPoint.init(x: contentFrame.width * (-2), y: 0)
        if let _ = shimmerLayer.animation(forKey: animationKey) {
            shimmerLayer.removeAnimation(forKey: animationKey)
        }
        let duration = 0.00431 * frame.width
        shimmerLayer.add(animation(duration: CFTimeInterval(duration)), forKey: animationKey)
    }
    
    
    
    lazy var progressLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect.zero
        layer.backgroundColor = progressColor.cgColor
        return layer
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius(self.frame.height / 2.0)
        
        if buttonStatus == .waiting {
//            addMask()
//            updateMask()
            updateProgress()
        } else if buttonStatus == .progress {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(CommonColor.mainDisableColor, for: .disabled)
        self.layer.addSublayer(progressLayer)
        self.borderColor(self.borderColor, width: 2)
        self.setBackgroundImage(CommonImage.imageWithColor(color: .white), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProgressButton:CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            
        }
    }
}
