//
//  UnderLineTextField.swift
//  MiniEye
//
//  Created by danhui.quan on 2019/6/22.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit


class UnderLineTextField: BasicView {
    
    var isShowRightButton : Bool = false {
        didSet {
            self.rightButton.isHidden = !self.isShowRightButton
            setNeedsUpdateConstraints()
        }
    }
    
    var isShowUnderLine : Bool = false {
        didSet {
            self.underLineView.isHidden = !self.isShowUnderLine
        }
    }


    lazy var underLineView:BasicView = {
        let view = BasicView.init()
        view.backgroundColor = CommonColor.seperatorLine
        view.isHidden = true
        return view
    }()
    
    lazy var textField:AccountTextField = {
        let textF = AccountTextField.init()
        textF.font = CommonFont.commonTitleFont
        textF.textColor = CommonColor.text
        textF.tintColor = CommonColor.blue
        textF.rightView = self.secureButton
        textF.rightViewMode = .never
        return textF
    }()
    
    lazy var rightButton:BasicButton = {
        let button = BasicButton.init(type: UIButton.ButtonType.custom)
        button.borderColor(CommonColor.blue,width:1).cornerRadius(15)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        button.setTitleColor(CommonColor.mainColor, for: .normal)
        button.setTitleColor(CommonColor.mainDisableColor, for: .disabled)
        button.titleLabel?.font = CommonFont.detailFont
        return button
    }()

    lazy var secureButton:BasicButton = {
        let button = BasicButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage.init(named: "me_eye"), for: .normal)
        button.setImage(UIImage.init(named: "me_eye_closed"), for: .selected)
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 24)
        button.addTarget(self, action: #selector(secureButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    @objc func secureButtonAction(sender:UIButton) {
        secureButton.isSelected = !secureButton.isSelected
        textField.isSecureTextEntry = secureButton.isSelected
    }
    
    func isShowSecureButton(_ isShow:Bool) {
        self.isSecureTextEntry = isShow
        textField.rightViewMode = isShow ? .always : .never
    }

    var isSecureTextEntry:Bool = false {
        didSet {
            secureButton.isSelected = isSecureTextEntry
            textField.isSecureTextEntry = secureButton.isSelected
        }
    }
    
    override func updateConstraints() {
        textField.mas_remakeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.top.equalTo()(self)
            make?.height.mas_equalTo()(defaultButtonHeight)
            if self.isShowRightButton {
                make?.right.equalTo()(self.rightButton.mas_left)
            } else {
                make?.right.equalTo()(self)
            }
            make?.bottom.lessThanOrEqualTo()(self)
        }

        rightButton.sizeToFit()
        rightButton.isHidden = !self.isShowRightButton
        if self.isShowRightButton {
            rightButton.mas_remakeConstraints { (make) in
                make?.centerY.equalTo()(self.textField)
                make?.right.equalTo()(self)
                var size = self.rightButton.bounds.size
                size.height = 30
                make?.size.mas_equalTo()(size)
            }
        }
        super.updateConstraints()
    }
    
    func configSubview() {
        addSubview(textField)
        addSubview(underLineView)
        addSubview(rightButton)
        
        backgroundColor = .white
        
        textField.mas_remakeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.top.equalTo()(self)
            make?.height.mas_equalTo()(defaultButtonHeight)
            if self.isShowRightButton {
                make?.right.equalTo()(self.rightButton.mas_left)
            } else {
                make?.right.equalTo()(self)
            }
            make?.bottom.lessThanOrEqualTo()(self)
        }
        
        rightButton.sizeToFit()
        rightButton.isHidden = !self.isShowRightButton
        if self.isShowRightButton {
            rightButton.mas_remakeConstraints { (make) in
                make?.centerY.equalTo()(self.textField)
                make?.right.equalTo()(self)
                var size = self.rightButton.bounds.size
                size.height = 30
                make?.size.mas_equalTo()(size)
            }
        }

        underLineView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.textField.mas_bottom)
            make?.left.right()?.equalTo()(self)
            make?.height.mas_equalTo()(CommonDimension.seperatorheight)
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
