//
//  CommonAlumImageCollectionViewCell.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/22.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit


class CommonAlbumImageCollectionViewHeader : UICollectionReusableView {
    
   
    lazy  var timeLabel:BasicLabel = {
        let label = BasicLabel.initWith(text: "哥就是一个传说")
        label.textAlignment = .left
        label.font = CommonFont.content
        
        return label
    }()
    
    
    var timeString:String? {
        didSet{
            if let trStr = timeString {
                timeLabel.text = trStr
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureSubviews() -> () {
        addSubview(timeLabel)
        
        timeLabel.sizeToFit()
        timeLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(defaultCellContentHorizitalMargin)
            make?.right.equalTo()(self)?.offset()(-defaultCellContentHorizitalMargin)
            make?.top.bottom().equalTo()(self)
        }
    }
    
}


let CommonAlumCollectionViewCellID = "CommonAlumCollectionViewCellID"

class CommonAlumCollectionViewCell: UICollectionViewCell {
    
    let maxImageScale:CGFloat = 3
    let minImageScale:CGFloat = 1
    
    enum controlType:String {
        case play
    }
    
   static let playContainerViewTag = 1000
    
    lazy var scrollViewContainer:BasicScrollView = {
        let scrollView = BasicScrollView.init()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        let tapScrollGesture = UITapGestureRecognizer.init(target: self, action: #selector(scrollViewContainerIsTapped(sender:)))
        tapScrollGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapScrollGesture)
        let pinchScrollGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(scrollViewContainerIsPinch(sender:)))
        scrollView.addGestureRecognizer(pinchScrollGesture)
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var contentImageView:BasicImageView = {
        let imageV = BasicImageView.init()
        imageV.image = CommonImage.placeHolder_Square
        imageV.contentMode = UIView.ContentMode.scaleAspectFit
        imageV.clipsToBounds = true
        imageV.tag = CommonAlumCollectionViewCell.playContainerViewTag
        imageV.isUserInteractionEnabled = true
        imageV.backgroundColor = UIColor.clear
        return imageV
    }()
    
    
    lazy var selectedCoverImage:BasicButton = {
        
        let button = BasicButton.init()
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        button.isHidden = true
//        button.image = UIImage.init(named: "imageChosen")!
        button.setImage( UIImage.init(named: "imageChosen")!, for: UIControl.State.normal)
//        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var coverBG:BasicView = {
        
        let view = BasicView.init()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        
        return view
    }()
    
    let tinySize:CGFloat = 12
    
    lazy var durationLabel:BasicLabel = {
        
        let label = BasicLabel.init()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: tinySize)
        label.textColor = UIColor.white
        label.text = "时长00:00:00"
        
        return label
    }()
    
    lazy var progressView: ProgressHUD = {
        let progressView = ProgressHUD.init()
        progressView.mode = .determinate
        progressView.label.text = "图片正在加载中"
        progressView.label.font = UIFont.mediumAppFont(ofSize: 17)
        progressView.label.textColor = CommonColor.explainBG
        return progressView
    }()
    
    lazy var timeLabel:BasicLabel = {
        
        let label = BasicLabel.init()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: tinySize)
        label.textColor = UIColor.white
        
        return label
    }()
    
    
    lazy var playButton:BasicButton = {
        
        let button = BasicButton.init(type: UIButton.ButtonType.custom)
        button.setImage(CommonImage.albumPlayImage, for: UIControl.State.normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(self.controlIsTapped(sender:)), for: UIControl.Event.touchUpInside)
        button.setViewDescribe(string: controlType.play.rawValue)
        
        return button
    }()
    
   
    var model: AlbumItem? {
        didSet{
            guard let tModel = model else {
                return
            }
            
//            切换cell的时候，将scrollViewContainer的zoom值恢复到1（重用）；
            scrollViewContainer.setZoomScale(1, animated: false)
            scrollViewContainer.contentSize = scrollViewContainer.bounds.size
            if  tModel.isThumbnailImage == false {
                scrollViewContainer.isUserInteractionEnabled = true
                if tModel.isVedio == false {
                    scrollViewContainer.bouncesZoom = true
                    scrollViewContainer.minimumZoomScale = minImageScale
                    scrollViewContainer.maximumZoomScale = maxImageScale
                }else{
                    scrollViewContainer.bouncesZoom = false
                    scrollViewContainer.minimumZoomScale = 1
                    scrollViewContainer.maximumZoomScale = 1
                }
            } else {
                scrollViewContainer.isUserInteractionEnabled = false
            }
            
            coverBG.isHidden = !tModel.isThumbnailImage
            
//MARK: 本地相册
            if let trModel = tModel as? CommonAlbumItemModel {
                progressView.isHidden = true
                selectedCoverImage.isHidden = !trModel.isSelected || !trModel.isChosenStyle
                                 
                contentImageView.image = trModel.image ?? CommonImage.placeHolder_Square
                if let image = UIImage.imageFromMemoryFor(key: trModel.phasset.localIdentifier) {
                    contentImageView.image = image
                }
                
                if !trModel.isThumbnailImage {
                    contentImageView.contentMode = UIView.ContentMode.scaleAspectFit
                    playButton.isHidden = !trModel.isVedio
                    durationLabel.isHidden = true
                    
                }else{
                    contentImageView.contentMode = UIView.ContentMode.scaleAspectFill
                    playButton.isHidden = true
                    
                    if  trModel.isVedio {
                        durationLabel.isHidden = false
                        durationLabel.text = "时长".localized + trModel.phasset.duration.changeToTimeString(Double.style.hh_mm_ss)!
                    }else{
                        durationLabel.isHidden = true
                    }
                    
                    let dateFormatter = DateFormatter.init()
                    dateFormatter.dateFormat = "HH:mm"
                    if let date = trModel.phasset.creationDate{
                        timeLabel.text = dateFormatter.string(from:date)
                    }else{
                        timeLabel.text = ""
                    }
                }
            }
            
//MARK:设备相册
            if let trModel = tModel as? CommonNetAlbumItemModel {
                selectedCoverImage.isHidden = true
                
                if trModel.isVedio {
                    progressView.hide(animated: false)
                    contentImageView.sd_cancelCurrentImageLoad()
                    contentImageView.image = nil
                    contentImageView.backgroundColor = UIColor.black
                } else {
                    contentImageView.backgroundColor = UIColor.clear
                    if  let urlString = trModel.imageUrlStr,let image = SDImageCache.shared.imageFromDiskCache(forKey: MEHost.deviceHost + urlString) {
                        progressView.hide(animated: false)
                        contentImageView.image = image
                    }else {
                        let shouldSDLoad:Bool = {
                            if oldValue == nil{
                                return true
                            }else if let oldModel = oldValue as? CommonNetAlbumItemModel {
                                if oldModel.mediaID != trModel.mediaID {
                                    return true
                                }else{
                                    return false
                                }
                            }else {
                                return false
                            }
                        }()
                        
                        if shouldSDLoad {
                            progressView.show(animated: true)
                            progressView.progress = 0
                            //注意，同一个cell可能会触发N个sd_setImage（Cell会重用），所以所有的回调一定要根据url来同步；
                            contentImageView.sd_setImage(with: trModel.imageUrl, placeholderImage:nil, options: [.retryFailed,.handleCookies], progress: { (receivedSize, expectedSize, url) in
                               
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self,let tModel = self.model as? CommonNetAlbumItemModel,
                                        url == tModel.imageUrl else {return}
                                    let progress = Progress.init(totalUnitCount: Int64(expectedSize))
                                    progress.completedUnitCount = Int64(receivedSize)
                                    self.progressView.show(animated: true)
                                    self.progressView.progress = Float(progress.fractionCompleted)
                                    print_Debug(message: "cell load  for media=\(String(describing: trModel.mediaID)),progress=\(progress.fractionCompleted)")
                                }
                                
                            }) { [weak self](image, error, isCache, url) in
                                guard let self = self else { return }
                                
                                if let model = self.model as? CommonNetAlbumItemModel, model.imageUrl ==  url {
                                    self.progressView.hide(animated: true)
                                    if let image = image {
                                        self.contentImageView.image = image
                                    }else {
                                        CommonPromptHUD.showError("图片下载失败，请稍后再试".localized, on: self.contentImageView, hideAfter: 3)
                                        self.contentImageView.image = CommonImage.imagePlaceHolder
                                        print_Debug(message: "sd_setImage completed image=\(image),error=\(error),isCache=\(isCache),url=\(url)")
                                    }
                                }
                            }
                        }else{
                            //如果是同一个 image model，作为被第二次写入（更新model状态），此时应该什么都不做；因为第一次已经开始加载了；
                        }
                    }
                }
//           大图状态，也即是是浏览图
                if !trModel.isThumbnailImage {
                    
                    contentImageView.contentMode = .scaleAspectFit
                    playButton.isHidden = !trModel.isVedio
                    durationLabel.isHidden = true
                    timeLabel.isHidden = true
                    
                }else{
//                    缩略图，也即是相册图；
                    contentImageView.contentMode = UIView.ContentMode.scaleAspectFill
                    playButton.isHidden = true
                    
                    if  trModel.isVedio {
                        durationLabel.isHidden = false
                        if let dration = trModel.duration {
                            durationLabel.text = "时长".localized +  (dration.changeToTimeString(Double.style.hh_mm_ss) ?? "00:00:00")
                        }
                    }else{
                        durationLabel.isHidden = true
                    }
                }
            }
        }
    }
    
    var controlIsTapped:ControlClicked?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    func configureSubviews() -> () {
        addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(contentImageView)
        contentImageView.addSubview(coverBG)
        contentImageView.addSubview(playButton)
        contentImageView.addSubview(progressView)
        addSubview(selectedCoverImage)
        addSubview(durationLabel)
        addSubview(timeLabel)
        selectedCoverImage.isHidden = true
        
        scrollViewContainer.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        coverBG.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        selectedCoverImage.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.contentImageView)
        }
        
        durationLabel.sizeToFit()
        var size = durationLabel.intrinsicContentSize
        size.width = size.width + 10
        durationLabel.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-5)
            make?.bottom.equalTo()(self)?.offset()(-5)
            make?.size.mas_equalTo()(size)
        }
        
        
        playButton.mas_makeConstraints { (make) in
            make?.center.equalTo()(self.contentImageView)
            make?.size.mas_equalTo()(CGSize.init(width: 44, height: 44))
        }
        
        
        timeLabel.sizeToFit()
        timeLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(5)
            make?.right.greaterThanOrEqualTo()(self.durationLabel.mas_left)?.offset()(-5)
            make?.bottom.equalTo()(self)?.offset()(-5)
            make?.height.equalTo()(self.durationLabel)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if contentImageView.frame.isEmpty,scrollViewContainer.bounds.isEmpty == false {
            contentImageView.frame = scrollViewContainer.bounds
        }
    }
    
    func setHighQualityContentImage() -> () {
        if let trModel = self.model as? CommonAlbumItemModel {
            contentImageView.image = UIImage.imageFromMemoryFor(key: trModel.phasset.localIdentifier)
        }
    }


}

//MARK: - target action && private method -
extension CommonAlumCollectionViewCell:UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        guard scrollView == scrollViewContainer,scrollView.isUserInteractionEnabled else {
            return nil
        }
        return contentImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print_Debug(message: "scrollViewDidZoom")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print_Debug(message: "scrollViewDidEndZooming atScale=\(scale)")
    }
    
    @objc func scrollViewContainerIsTapped(sender:UITapGestureRecognizer) -> () {
        guard let tModel = model,tModel.isVedio == false else {
            return
        }
        let view = (sender.view as! BasicScrollView)
        view.setZoomScale(view.zoomScale > 1 ? minImageScale : maxImageScale, animated: true)
    }
    
    @objc func scrollViewContainerIsPinch(sender:UIPinchGestureRecognizer) -> () {
        guard let tModel = model,tModel.isVedio == false else {
            return
        }
        let view = (sender.view as! BasicScrollView)
        var scale:CGFloat = sender.scale
        if scale > maxImageScale {
            scale = maxImageScale
        } else if scale < minImageScale {
            scale = minImageScale
        }
        view.setZoomScale(scale, animated: true)
    }
    
    @objc func controlIsTapped(sender:UIControl) -> () {
        if let trBlock = controlIsTapped {
            trBlock(sender,UIControl.Event.touchUpInside)
        }
    }

    
}
