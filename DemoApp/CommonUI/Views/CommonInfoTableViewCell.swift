//
//  MyTableViewCell.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/8.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit
import Masonry

let  CommonInfoTableViewCellId = "commonInfoTableViewCellID"

class CommonInfoTableViewCell: UITableViewCell {
    
    let bageWidth:CGFloat = 8
    let elementMargin:CGFloat = 12
    let horizalMargin:CGFloat = 20
    let verticalMargin:CGFloat = 20
    let rightContentImageViewHeight:CGFloat = 60
    
    lazy var leftImageView:BasicImageView = {
        let imageV = BasicImageView.init()
        
        return imageV
    }()
    
    lazy var rightBageView:BasicLabel = {
        let label = BasicLabel.init()
        label.backgroundColor = CommonColor.redColor
        label.isHidden = true
        return label
    }()

    
    lazy var titleBageButton:BasicButton = {
        let button = BasicButton.init()
        button.setImage(UIImage(named: "me_bage"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(bageButtonAction(sneder:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var rightSwitch:UISwitch = {
        let switchView = UISwitch.init()
        switchView.onTintColor = CommonColor.mainColor
        switchView.addTarget(self, action: #selector(viewIsTapped(sender:)), for: UIControl.Event.valueChanged)
        switchView.isHidden = true
        
        return switchView
    }()
    
    
    lazy var rightImageView:BasicImageView = {
        let imageV = BasicImageView.init()
        return imageV
    }()
    
    lazy var rightContentImageView:BasicImageView = {
        let imageV = BasicImageView.init()
        imageV.cornerRadius(5)
        return imageV
    }()
    
    lazy var titleLabel:BasicLabel  = {
        let label = BasicLabel.initWith(text: "",
                                        font: CommonFont.commonTitleFont,
                                        textColor: CommonColor.subTitleColor,
                                        textAlignment: .left)
        return label
    }()
    
    lazy var contentLabel:BasicLabel  = {
        let label = BasicLabel.initWith(text: nil,
                                        font: CommonFont.commonTitleFont,
                                        textColor: CommonColor.detailColor)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    lazy var subTitleLabel:BasicLabel  = {
        let label = BasicLabel.initWith(text: nil,
                                        font: CommonFont.detail,
                                        textColor: UIColor.colorWithHex(hex: 0xCECECE))
        label.textAlignment = .left
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    
    lazy var slider:UISlider  = {
        let slider = UISlider.init()
        slider.minimumTrackTintColor = CommonColor.mainColor
        slider.maximumTrackTintColor = CommonColor.sliderMaxTintColor
        slider.maximumValue = 10
        slider.minimumValue = 0
        slider.isContinuous = false
        slider.isHidden = true
        slider.addTarget(self, action: #selector(viewIsTapped(sender:)), for: .valueChanged)
        return slider
    }()
    
    var model:CommonInfoModel?{
        didSet{
            guard let trModel = model else {
                return
            }
            configureSubviews(with:trModel)
        }
    }
    
    var switchChangeBlock:ControlClicked?
    var sliderChangeBlock:ControlClicked?

    var isShowTitleBage:Bool {
        set {
            self.titleBageButton.isHidden = !newValue
        }
        get {
            return self.titleBageButton.isHidden
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSubviews() {
        backgroundColor = CommonColor.viewBG
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(titleBageButton)
        addSubview(contentLabel)
        addSubview(rightImageView)
        addSubview(rightSwitch)
        addSubview(rightContentImageView)
        addSubview(slider)
        addSubview(subTitleLabel)
        addSubview(rightBageView)
    }
    
    func configureSubviews(with model:CommonInfoModel) -> () {
        var lelftBasicView:UIView = self
        var rightBasicView:UIView = self
        
        if let imageInfo = model.leftImageInfo {
            CommonInfoModel.setImageFor(imageView: leftImageView, with: imageInfo)
            lelftBasicView = leftImageView
            leftImageView.isHidden = false

            leftImageView.sizeToFit()
            leftImageView.mas_makeConstraints { (make) in
                make?.centerY.equalTo()(self.titleLabel)
                make?.left.equalTo()(self)?.offset()(self.horizalMargin)
                make?.top.greaterThanOrEqualTo()(self)?.offset()(self.verticalMargin)
                make?.bottom.lessThanOrEqualTo()(self)?.offset()(-self.verticalMargin)
            }
            
        }else{
            leftImageView.isHidden = true
        }
        
        if let title = model.title {
            titleLabel.text = title
            titleLabel.sizeToFit()
            
            var leftMargin:CGFloat = self.horizalMargin
            
            if  lelftBasicView == leftImageView {
                leftMargin = elementMargin + (leftImageView.image?.size.width)!
            }
            titleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
            contentLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)

            titleLabel.mas_makeConstraints { (make) in
                make?.left.equalTo()(lelftBasicView)?.offset()(leftMargin)
//                make?.centerY.equalTo()(self)
                make?.top.greaterThanOrEqualTo()(self)?.offset()(self.verticalMargin)
                make?.bottom.lessThanOrEqualTo()(self)?.offset()(-self.verticalMargin)
            }
            titleBageButton.mas_makeConstraints { (make) in
                make?.left.equalTo()(self.titleLabel.mas_right)?.offset()(self.bageWidth * 0.5)
                make?.centerY.equalTo()(self.titleLabel)
                make?.width.equalTo()(self.bageWidth)
                make?.height.equalTo()(self.bageWidth)
            }
        }
        
        
        if let imageInfo = model.rightImageInfo {
            CommonInfoModel.setImageFor(imageView: rightImageView, with: imageInfo)
            rightBasicView = rightImageView
            rightImageView.isHidden = false
            rightSwitch.isHidden = true
        } else {
            rightImageView.isHidden = true
            
            if let _ = model.rightSwitchInfo {
                rightBasicView = rightSwitch
                rightSwitch.isOn = model.rightSwitchInfo?.value as! Bool
                rightSwitch.isHidden = false
            }else{
                rightSwitch.isHidden = true
                
                if let content = model.content {
                    contentLabel.text = content
                    rightBasicView = contentLabel
                    contentLabel.isHidden = false
                    contentLabel.mas_makeConstraints { (make) in
                        make?.left.equalTo()(self.titleLabel.mas_right)
                        make?.right.equalTo()(self)?.offset()(-self.horizalMargin)
                        make?.top.equalTo()(self.titleLabel)
                        make?.bottom.lessThanOrEqualTo()(self)?.offset()(-self.verticalMargin)
                    }
                }else{
                    contentLabel.isHidden = true
                }
            }
        }
        
        if rightBasicView != self {
            rightBasicView.sizeToFit()
            rightBasicView.mas_makeConstraints { (make) in
                make?.centerY.equalTo()(self.titleLabel)
                make?.right.equalTo()(self)?.offset()(-self.horizalMargin)
                make?.top.greaterThanOrEqualTo()(self)?.offset()(self.verticalMargin)
                make?.bottom.lessThanOrEqualTo()(self)?.offset()(-self.verticalMargin)
            }
        }
        
        
        if rightBasicView == rightImageView {
            if let content = model.content {
                contentLabel.text = content
                contentLabel.isHidden = false
                
                contentLabel.mas_makeConstraints { (make) in
                    make?.left.equalTo()(self.titleLabel.mas_right)
                    make?.top.equalTo()(self.titleLabel)
                }
                rightImageView.sizeToFit()
                rightImageView.mas_makeConstraints { (make) in
                    make?.left.equalTo()(self.contentLabel.mas_right)?.offset()(self.elementMargin)
                    make?.size.equalTo()(self.rightImageView.frame.size)
                }
            }else{
                contentLabel.isHidden = true
                
                if let imageInfo = model.rightContentImageInfo {
                    CommonInfoModel.setImageFor(imageView: rightContentImageView, with:imageInfo)
                    rightContentImageView.isHidden = false
                    
                    rightContentImageView.mas_makeConstraints { (make) in
                        make?.centerY.equalTo()(self.titleLabel)
                        make?.right.equalTo()(self.rightImageView.mas_left)?.offset()(-self.elementMargin)
                        make?.top.greaterThanOrEqualTo()(self)?.offset()(self.verticalMargin)
                        make?.bottom.lessThanOrEqualTo()(self)?.offset()(-self.verticalMargin)
                        make?.size.equalTo()(CGSize.init(width: 60, height: 60))
                    }
                
               }else{
                    rightContentImageView.isHidden = true
                }
            }
        }
        
        if let _ = model.subTitle {
            subTitleLabel.isHidden = false
            subTitleLabel.sizeToFit()
            subTitleLabel.text = model.subTitle
            subTitleLabel.mas_makeConstraints { (make) in
                make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(7)
                make?.left.equalTo()(self.titleLabel)
                make?.right.equalTo()(self)?.offset()(-self.horizalMargin)
                make?.bottom.lessThanOrEqualTo()(self)
            }
        }
        if rightSwitch.isHidden {
            for constraint in MASViewConstraint.installedConstraints(for: rightSwitch) {
                if let t = constraint as? MASViewConstraint {
                    t.uninstall()
                }
            }
        } else {
            contentLabel.isHidden = true
        }
        
        if let sliderInfo = model.sliderInfo {
            slider.isHidden = false
            subTitleLabel.isHidden = true
            var number:Float = 5
            if let value = sliderInfo.value {
                if (value is Double) {
                    number = Float(value as! Double)
                } else if (value is Int) {
                    number = Float(value as! Int)
                } else if (value is Float) {
                    number = value as! Float
                }
            }
            slider.value = number
            slider.mas_makeConstraints { (make) in
                make?.centerX.equalTo()(self)
                make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(5)
                make?.left.equalTo()(self)?.offset()(2 * self.horizalMargin)
                make?.right.equalTo()(self)?.offset()(-2 * self.horizalMargin)
                make?.bottom.lessThanOrEqualTo()(self)?.offset()(-self.verticalMargin)
            }
        } else {
            slider.isHidden = true
            for constraint in MASViewConstraint.installedConstraints(for: slider) {
                if let t = constraint as? MASViewConstraint {
                    t.uninstall()
                }
            }
        }
        
        rightBageView.cornerRadius(5)
        rightBageView.mas_makeConstraints { (make) in
            make?.size.equalTo()(CGSize.init(width: 10, height: 10))
            make?.centerY.equalTo()(self.titleLabel)
            make?.right.equalTo()(self)?.offset()(-40)
        }
    }
    
    
    @objc func bageButtonAction(sneder:UIButton) {
        print_Debug(message: "title bage click")
    }
    
    @objc func viewIsTapped(sender:NSObject) {
        if sender == self.slider {
            if let _ = self.sliderChangeBlock {
                self.sliderChangeBlock!(sender as! UISlider, .valueChanged)
            }
        } else if sender == self.rightSwitch {
            if let trChangebloc = switchChangeBlock {
                trChangebloc(sender as! UISwitch, .valueChanged)
            }
        }
        print_Debug(message: "viewDebug is tapped", prlogLevel: LogLevel.testClose)
    }
    
}
