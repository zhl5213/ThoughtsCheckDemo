//
//  ChatSessionTableViewCell.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/23.
//

import UIKit

protocol SessionDataSource {
    func sessionData() -> (avertorImage:UIImage,content:String,isAnother:Bool)
}

class ChatSessionTableViewCell: UITableViewCell {
    
    static let reuseID = "ChatSessionTableViewCellID"
    
    lazy var anotherAvartor:UIButton = {
        let button = UIButton.init(type: .custom)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var myAvartor:UIButton = {
        let button = UIButton.init(type: .custom)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        return button
    }()

    
    lazy var anotherContentLabel: UILabel = {
        return createLabel(isMy: false)
    }()
    
    lazy var myContentLabel: UILabel = {
        return createLabel(isMy: true)
    }()
    
    private func createLabel(isMy:Bool) -> UILabel {
        let label = UILabel.init()
        label.backgroundColor = isMy ? UIColor.green : UIColor.white
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }
    
    var dataSource:SessionDataSource? {
        didSet{
            guard let trData = dataSource?.sessionData() else {
                return
            }
            myAvartor.isHidden = trData.isAnother
            myContentLabel.isHidden = trData.isAnother
            
            anotherAvartor.isHidden = !trData.isAnother
            anotherContentLabel.isHidden = !trData.isAnother
                        
            (trData.isAnother ? anotherAvartor : myAvartor).setImage(trData.avertorImage, for: .normal)
            if trData.isAnother {
                anotherContentLabel.text = trData.content
                myContentLabel.text = nil
            }else {
                myContentLabel.text = trData.content
                anotherContentLabel.text = nil
            }
//            contentLabel.sizeToFit()
//            contentLabel.mas_updateConstraints { [unowned contentLabel] (make) in
//                make?.height.equalTo()(contentLabel.intrinsicContentSize.height)
//            }
//            contentLabel.setNeedsUpdateConstraints()
            updateSubviewsConstraints()
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        backgroundColor = CommonColor.systemBGGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureSubviews() -> () {
        contentView.isUserInteractionEnabled = false
        myContentLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        anotherContentLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        anotherContentLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        myContentLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        addSubview(anotherAvartor)
        addSubview(anotherContentLabel)
        addSubview(myContentLabel)
        addSubview(myAvartor)
        
        updateSubviewsConstraints()
    }
    
    func updateSubviewsConstraints() -> () {
        anotherAvartor.mas_remakeConstraints { (make) in
            make?.top.offset()(5)
            make?.left.offset()(10)
            make?.bottom.lessThanOrEqualTo()(self)?.offset()(-5)
            make?.size.equalTo()(CGSize.init(width: 44, height: 44))
        }
        
        anotherContentLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.anotherAvartor)
            make?.left.equalTo()(self.anotherAvartor.mas_right)?.offset()(10)
            make?.right.lessThanOrEqualTo()(self.myAvartor.mas_left)?.offset()(-10)
            make?.bottom.lessThanOrEqualTo()(self)?.offset()(-5)
        }
        
        myAvartor.mas_makeConstraints { (make) in
            make?.top.offset()(5)
            make?.right.offset()(-10)
            make?.bottom.lessThanOrEqualTo()(self)?.offset()(-5)
            make?.size.equalTo()(CGSize.init(width: 44, height: 44))
        }
        
        myContentLabel.mas_remakeConstraints { (make) in
            make?.top.equalTo()(self.myAvartor)
            make?.right.equalTo()(self.myAvartor.mas_left)?.offset()(-10)
            make?.left.greaterThanOrEqualTo()(self.anotherAvartor.mas_right)?.offset()(10)
            make?.bottom.lessThanOrEqualTo()(self)?.offset()(-5)
        }
    }
    
    @objc func buttonIsTapped(sender:UIButton) -> () {
        
    }
    
    
    
}
