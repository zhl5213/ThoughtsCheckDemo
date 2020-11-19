//
//  AVPlayerSubtile.swift
//  MiniEye
//
//  Created by 朱慧林 on 2020/7/13.
//  Copyright © 2020 MINIEYE. All rights reserved.
//

import Foundation


struct SubtitleShowConfigure {
    var titleLabel:BasicLabel
    enum Position {
        case bottomLeft
        case bottomCenter
        case topLeft
        case topCenter
        case other(location:CGRect)
    }
    var positionMargin:UIEdgeInsets = UIEdgeInsets.zero
    var postion:Position = .bottomLeft
    
    var showPlayTime:TimeInterval = 0
    var hidePlayTime:TimeInterval = 0
}

protocol PlayerSubtitle:NSObject {
    var playerContainer:UIView? {set get}
    var avPlayer:AVPlayer{get}
    var timeObserver:Any? {set get}
    var timeObserverBlocks:[(CMTime)->()] {set get}
    var subtitleConfigures:[SubtitleShowConfigure] {set get}
    
    func addSubtitleWithConfigure(_ configure:SubtitleShowConfigure) -> ()
}

extension PlayerSubtitle {
    
    func addSubtitleWithConfigure(_ configure:SubtitleShowConfigure) -> () {
        guard let playerContainer = playerContainer else {
            fatalError("playerContainer is nil,addSubtitleWithConfigure failed")
        }
        configure.titleLabel.alpha = 0
        playerContainer.addSubview(configure.titleLabel)
        
        configure.titleLabel.mas_makeConstraints { (make) in
            make?.left.greaterThanOrEqualTo()(playerContainer.mas_left)?.offset()(configure.positionMargin.left)
            make?.right.lessThanOrEqualTo()(playerContainer.mas_right)?.offset()(-configure.positionMargin.right)
            make?.top.greaterThanOrEqualTo()(playerContainer.mas_top)?.offset()(configure.positionMargin.top)
            make?.bottom.lessThanOrEqualTo()(playerContainer.mas_bottom)?.offset()(-configure.positionMargin.bottom)
        }
        switch configure.postion {
        case .bottomLeft:
            configure.titleLabel.mas_updateConstraints { (make) in
                make?.left.offset()(configure.positionMargin.left)
                make?.bottom.offset()(-configure.positionMargin.bottom)
            }
        case .bottomCenter:
            configure.titleLabel.mas_updateConstraints { (make) in
                make?.centerX.equalTo()
                make?.bottom.offset()(-configure.positionMargin.bottom)
            }
        case .topLeft:
            configure.titleLabel.mas_updateConstraints { (make) in
                make?.left.offset()(configure.positionMargin.left)
                make?.top.offset()(configure.positionMargin.top)
            }
        case .topCenter:
            configure.titleLabel.mas_updateConstraints { (make) in
                make?.centerX.equalTo()
                make?.top.offset()(configure.positionMargin.top)
            }
        case .other(location: let location):
            configure.titleLabel.mas_updateConstraints { (make) in
                make?.left.offset()(location.minX)
                make?.top.offset()(location.minY)
                make?.size.equalTo()(location.size)
            }
        }
        
        subtitleConfigures.append(configure)
        
        let observerBlock:(CMTime)->() = { [weak self](currentTime) in
            guard  let self = self else {
                return
            }
            
            let validShowTime = min(max(0, configure.showPlayTime), self.avPlayer.currentItem!.duration.seconds)
            let validHideTime = min(max(0, configure.hidePlayTime), self.avPlayer.currentItem!.duration.seconds)
            
            if currentTime.seconds >= validShowTime,currentTime.seconds <= validHideTime {
                if configure.titleLabel.alpha != 1 {
                    UIView.animate(withDuration: 0.25) {
                        configure.titleLabel.alpha = 1
                    }
                }
            }
            
            if currentTime.seconds >= validHideTime {
                if configure.titleLabel.alpha != 0 {
                    UIView.animate(withDuration: 0.25) {
                        configure.titleLabel.alpha = 0
                    }
                }
            }
        }
        timeObserverBlocks.append(observerBlock)
        
        if timeObserver == nil {
            let timeObserverInterval = CMTime.init(seconds: 0.1, preferredTimescale: CMTimeScale.init(NSEC_PER_SEC))
            timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeObserverInterval, queue: nil, using: { [weak self](currentTime) in
                guard  let self = self else {
                    return
                }
                for block in self.timeObserverBlocks {
                    block(currentTime)
                }
            })
        }
    }
    
}


//private func addTestSubtitle()  {
//       let configure1 = SubtitleShowConfigure.init(titleLabel: BasicLabel.initWith(text: "测试", font: UIFont.systemFont(ofSize: 15), textColor: UIColor.red, textAlignment: .left), positionMargin: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), postion: .bottomLeft, showPlayTime: 1, hidePlayTime: 3)
//
//       let configure2 = SubtitleShowConfigure.init(titleLabel: BasicLabel.initWith(text: "不动字幕", font: UIFont.systemFont(ofSize: 15), textColor: UIColor.green, textAlignment: .center), positionMargin: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), postion: .topCenter, showPlayTime: 0, hidePlayTime: Double.greatestFiniteMagnitude)
//       gifManager?.addSubtitleWithConfigure(configure1)
//       gifManager?.addSubtitleWithConfigure(configure2)
//
//   }
