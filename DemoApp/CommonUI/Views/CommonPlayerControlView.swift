//
//  CommonPlayerControlView.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/9/29.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

class CommonPlayerControlView: ZFPlayerControlView,RelyOnView {
    
    var relyOnViews: [BasicView] = [BasicView]()
    private let margin:CGFloat = 9
    var shouldHidePlayControlView = false {
        didSet {
            if shouldHidePlayControlView {
                portraitControlView.bottomToolView.isHidden = true
                portraitControlView.playOrPauseBtn.isHidden = true
                portraitControlView.slider.isHidden = true
                landScapeControlView.playOrPauseBtn.isHidden = true
                landScapeControlView.bottomToolView.isHidden = true
                landScapeControlView.slider.isHidden = true
                customDisablePanMovingDirection = true
            }
        }
    }
    
    var showScreenRotateControlView:Bool = false {
        didSet{
            fullScreenBtn.isHidden = !showScreenRotateControlView
            backBtn.isHidden = !showScreenRotateControlView
            lockBtn.isHidden = !showScreenRotateControlView
            landScapeControlView.backBtn.isHidden = showScreenRotateControlView
            landScapeControlView.lockBtn.isHidden = showScreenRotateControlView
        }
    }
    
    
    lazy var fullScreenBtn: BasicButton = {
        let button = BasicButton.init(type: .custom)
        button.setImage(UIImage.init(named: "全屏按钮"), for:.normal)
        button.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
        
    lazy var backBtn: BasicButton = {
        let button = BasicButton.init(type: .custom)
        button.setImage(UIImage.init(named: "全屏返回按钮"), for:.normal)
        button.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var lockBtn: BasicButton = {
        let button = BasicButton.init(type: .custom)
        button.setImage(UIImage.init(named: "关闭屏幕"), for: UIControl.State.normal)
        button.setImage(UIImage.init(named: "锁定屏幕"), for: UIControl.State.selected)
        button.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
///relyOnViews包含一些视图，这些视图添加到portraitControlView上，为了防止该视图遮挡原来的操作控制行为，将相关的视图failBtn、bottomToolView移到子视图上
    func addRelyOnSubview(_ view: BasicView) {
        portraitControlView.addSubview(view)
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CommonPlayerControlView.gestureSingleTapped(_:))))
        view.addSubview(portraitControlView.fullScreenBtn)
        portraitControlView.fullScreenBtn.mas_remakeConstraints { (make) in
            make?.right.bottom()?.offset()(-16.5)
        }
        view.addSubview(failBtn)
        relyOnViews.append(view)
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.landScapeControlView.playOrPauseBtn.setImage(UIImage.init(named: "播放"), for: UIControl.State.normal)
        self.landScapeControlView.playOrPauseBtn.setImage(UIImage.init(named: "暂停"), for: UIControl.State.selected)
        self.landScapeControlView.backBtn.setImage(UIImage.init(named: "全屏返回按钮"), for: UIControl.State.normal)
        self.landScapeControlView.lockBtn.setImage(UIImage.init(named: "关闭屏幕"), for: UIControl.State.normal)
        self.landScapeControlView.lockBtn.setImage(UIImage.init(named: "锁定屏幕"), for: UIControl.State.selected)
        self.portraitControlView.playOrPauseBtn.setImage(UIImage.init(named: "播放"), for: UIControl.State.normal)
        self.portraitControlView.playOrPauseBtn.setImage(UIImage.init(named: "暂停"), for: UIControl.State.selected)
        self.portraitControlView.fullScreenBtn.setImage(UIImage.init(named: "全屏按钮"), for: UIControl.State.normal)
        
        portraitControlView.addSubview(fullScreenBtn)
        fullScreenBtn.mas_makeConstraints { (make) in
            make?.right.bottom()?.offset()(-16.5)
        }
        landScapeControlView.addSubview(backBtn)
        landScapeControlView.addSubview(lockBtn)
        
        lockBtn.mas_remakeConstraints { (make) in
            make?.left.offset()(SafeStatusBarHeight)
            make?.centerY.offset()(-15)
        }
        
        let topViewCenterY:CGFloat = ((isIPhoneXSerial && self.player?.orientationObserver.fullScreenMode == ZFFullScreenMode.landscape) ? 15: (isIPhoneXSerial ? 40 : 20)) + 20

        backBtn.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.lockBtn)
            make?.centerY.equalTo()(self.landScapeControlView.mas_top)?.offset()(topViewCenterY)
            make?.size.mas_equalTo()(CGSize.init(width: 50, height: 50))
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for relyView in relyOnViews {
            relyView.setNeedsLayout()
        }
    }
    
    @objc func buttonIsTapped(sender:BasicButton) -> () {
        if sender == fullScreenBtn {
            player?.enterFullScreen(true, animated: true)
        } else if sender == backBtn {
            player?.enterFullScreen(false, animated: true)
        }else if sender == lockBtn {
            lockBtn.isSelected =  !lockBtn.isSelected
            player?.isLockedScreen = lockBtn.isSelected
        }
    }
    
    override func lockedVideoPlayer(_ videoPlayer: ZFPlayerController, lockedScreen locked: Bool) {
        if showScreenRotateControlView == false {
            super.lockedVideoPlayer(videoPlayer, lockedScreen: locked)
        }
    }
    
///当存在relyOnViews时，旋转视图的时候，需要将relyOnViews在portraitControlView和landScapeControlView之间转移
    override func videoPlayer(_ videoPlayer: ZFPlayerController, orientationWillChange observer: ZFOrientationObserver) {
        super.videoPlayer(videoPlayer, orientationWillChange: observer)
        for view in relyOnViews {
            if portraitControlView.isHidden {
                landScapeControlView.addSubview(view)
                view.addSubview(landScapeControlView.backBtn)
                view.addSubview(landScapeControlView.lockBtn)
                landScapeControlView.lockBtn.mas_remakeConstraints { (make) in
                    make?.left.offset()(44 + self.margin)
                    make?.bottom.offset()(-15)
                }
                portraitControlView.addSubview(portraitControlView.fullScreenBtn)
            }else{
                portraitControlView.addSubview(view)
                landScapeControlView.lockBtn.mas_remakeConstraints { (make) in }
                landScapeControlView.addSubview(landScapeControlView.backBtn)
                landScapeControlView.addSubview(landScapeControlView.lockBtn)
                view.addSubview(portraitControlView.fullScreenBtn)
               portraitControlView.fullScreenBtn.mas_remakeConstraints { (make) in
                    make?.right.bottom()?.offset()(-16.5)
                }
            }
        }
    }
    
//        覆盖目的是在拖动滑杆到新的视频，加载新的视频的时候，不会隐藏掉controlView
    override func videoPlayer(_ videoPlayer: ZFPlayerController, prepareToPlay assetURL: URL) {}

}
