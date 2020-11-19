//
//  ChatTableViewCell.swift
//  DemoApp
//
//  Created by 朱慧林 on 2020/9/20.
//

import UIKit

//测试申明先后顺序和调用的关系，这样做没问题，可以顺利调用。无论这两个变量是 fileprivate 还是普通的声明
var anGlobalResuult:String = otherGlobalResult
var otherGlobalResult:String = {
   return "an old tree"
}()


extension UILabel {
    
    static func initWith(text: String?,
                         font: UIFont,
                         textColor: UIColor,
                         textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel.init()
        label.text = anGlobalResuult
        label.font = font
        label.textColor = textColor
        label.textAlignment  = textAlignment
        return label
    }
    
}

protocol ChatDataSource {
    
    func chatInfos() -> (lefImage:UIImage,hasBage:Bool,title:String,content:String?,time:String?,closeNotify:Bool)
}

class ChatInfoTableViewCell: UITableViewCell {

    static let reuseID = "ChatTableViewCellreuseID"
    
    lazy var leftImageView:UIImageView = {
        let imageV = UIImageView.init()
        imageV.layer.cornerRadius = 5
        imageV.layer.masksToBounds = true
        return imageV
    }()
    
    let bageEdgeWidth:CGFloat = 5
    
    lazy var leftBageView:UILabel = {
        let label = UILabel.init()
        label.backgroundColor = CommonColor.redColor
        label.layer.cornerRadius = bageEdgeWidth
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
   
    lazy var titleLabel:UILabel  = {
        let label = UILabel.initWith(text: "",
                                        font: CommonFont.commonTitleFont,
                                        textColor: CommonColor.titleColor,
                                        textAlignment: .left)
        return label
    }()
    
    lazy var contentLabel:UILabel  = {
        let label = UILabel.initWith(text: nil,
                                        font: CommonFont.contentFont,
                                        textColor: CommonColor.contentColor,textAlignment: .left)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var timeLabel:UILabel  = {
        let label = UILabel.initWith(text: nil,
                                        font: CommonFont.detail,
                                        textColor: UIColor.colorWithHex(hex: 0xCECECE),textAlignment: .right)
        return label
    }()

    lazy var notifyImageView:UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "关闭"))
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var dataSource:ChatDataSource?{
        didSet{
            if let trDataSource = dataSource {
                let chatInfos = trDataSource.chatInfos()
                leftImageView.image = chatInfos.lefImage
                leftBageView.isHidden = !chatInfos.hasBage
                titleLabel.text = chatInfos.title
                contentLabel.text = chatInfos.content
                timeLabel.text = chatInfos.time
                notifyImageView.isHidden = !chatInfos.closeNotify
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        configureSubviews()
        selectionStyle = .none
    }
    
    
    func configureSubviews() -> () {
        addSubview(leftImageView)
        addSubview(leftBageView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(timeLabel)
        addSubview(notifyImageView)
        
        leftImageView.mas_makeConstraints { (make) in
            make?.left.offset()(CommonDimension.mediumContentHorizitalMargin)
            make?.top.offset()(CommonDimension.mediumContentHorizitalMargin)
            make?.centerY.equalTo()
            make?.size.equalTo()(CGSize.init(width: 44, height: 44))
        }
        
        leftBageView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.leftImageView.mas_right)
            make?.centerY.equalTo()(self.leftImageView.mas_top)
            make?.size.equalTo()(CGSize.init(width: self.bageEdgeWidth * 2, height:  self.bageEdgeWidth * 2))
        }
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.leftImageView.mas_right)?.offset()(10)
            make?.bottom.equalTo()(self.leftImageView.mas_centerY)?.offset()(-3)
            make?.right.equalTo()(self.timeLabel.mas_left)?.offset()(-10)
        }
        
        contentLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.leftImageView.mas_right)?.offset()(10)
            make?.top.equalTo()(self.leftImageView.mas_centerY)?.offset()(3)
            make?.right.equalTo()(self.timeLabel.mas_left)?.offset()(-10)
        }
        
        timeLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.titleLabel)
            make?.right.offset()(-CommonDimension.mediumContentHorizitalMargin)
        }
        
        notifyImageView.mas_makeConstraints { (make) in
            make?.right.equalTo()(self.timeLabel)
            make?.centerY.equalTo()(self.contentLabel)
            make?.size.equalTo()(CGSize.init(width: 20, height: 20))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
