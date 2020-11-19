//
//  PhotoBrowserView.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/6/24.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit
import Photos

let localPhotoBrowser:PhotoBrowserView = PhotoBrowserView<CommonAlbumItemModel>()
let devicePhotoBrowser:PhotoBrowserView = PhotoBrowserView<CommonNetAlbumItemModel>()

class PhotoBrowserView <T:AlbumItem & Equatable>: BasicView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSourcePrefetching {
    
    var startRect:CGRect = CGRect.zero
    var photoFrom:String = "" {
        didSet{
            if self == devicePhotoBrowser {
                let albumType = DevicePhotoAlbum.init(rawValue: self.photoFrom)!
                titleLabel.text = albumType.localName()
            }else {
                titleLabel.text = photoFrom
            }
        }
    }
    
    var notiObservrations:[NSObjectProtocol] = [NSObjectProtocol]()
    var isShowing:Bool = false
    
    var shouldShowBar:Bool = false {
        didSet {
            navigationBar.isHidden = !shouldShowBar
        }
    }
    
    enum prepareType {
        case hide
        case show
    }
    
    var models:[CommonAlbumSectionModel<T>] {
        get{
            
            if self == devicePhotoBrowser {
                return deviceSectionModels as! [CommonAlbumSectionModel<T>]
            }
            
            switch photoFrom {
            case LocalPhotosDataManager.AlbumType.ADAS.rawValue:
                return LocalPhotosDataManager.shared.adasSectionModels as! [CommonAlbumSectionModel<T>]
            case LocalPhotosDataManager.AlbumType.myCapture.rawValue:
                return LocalPhotosDataManager.shared.myCaptureSectionModels as! [CommonAlbumSectionModel<T>]
            default:
                fatalError("no ther photo from")
            }
        }
        set{
            if self == devicePhotoBrowser {
                deviceSectionModels = newValue as! [CommonAlbumSectionModel<CommonNetAlbumItemModel>]
                return
            }
            switch photoFrom {
            case LocalPhotosDataManager.AlbumType.ADAS.rawValue:
                LocalPhotosDataManager.shared.adasSectionModels = newValue as! [CommonAlbumSectionModel<CommonAlbumItemModel>]
            case LocalPhotosDataManager.AlbumType.myCapture.rawValue:
                LocalPhotosDataManager.shared.myCaptureSectionModels = newValue as! [CommonAlbumSectionModel<CommonAlbumItemModel>]
            default:
                fatalError("no ther photo from")
            }
        }
    }
    
    var deviceSectionModels:[CommonAlbumSectionModel<CommonNetAlbumItemModel>] =  [CommonAlbumSectionModel<CommonNetAlbumItemModel>]()
    var deletedDeviceModels:[CommonNetAlbumItemModel] = [CommonNetAlbumItemModel]()
    
    lazy var navigationBar:BasicView = {
        
        let view = BasicView.init()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        
        return view
    }()
    
    lazy var cancelButton:BasicButton = {
        
        let button = BasicButton.init(type: UIButton.ButtonType.custom)
//        button.setImage(CommonImage.leftArrow, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(viewIsTapped(sender:)), for: UIControl.Event.touchUpInside)
        
        let imageView = UIImageView.init(image: CommonImage.leftArrow)
        button.addSubview(imageView)
        imageView.sizeToFit()
        imageView.mas_makeConstraints({ (make) in
            make?.left.centerY().equalTo()(button)
        })
        
        return button
    }()
    
    lazy var deleteButton:BasicButton = {
        
        let button = BasicButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("删除".localized, for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.setTitleColor(CommonColor.buttonDisableBG, for: .disabled)
        button.addTarget(self, action: #selector(viewIsTapped(sender:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    lazy var titleLabel:BasicLabel = {
        let label = BasicLabel.initWith(text: "AlbumTitle")
        label.textAlignment = .center
        label.font = CommonFont.title
        label.textColor = CommonColor.black
        
        return label
    }()
    
    lazy var promptLabel:BasicLabel = {
        let label = BasicLabel.initWith(text: "time")
        label.textAlignment = .center
        label.font = CommonFont.detail
        label.textColor = CommonColor.black
        
        return label
    }()
    
    
    
    lazy var collectionView:UICollectionView = {
        
        let flowOut = UICollectionViewFlowLayout.init()
        flowOut.minimumLineSpacing = 0
        flowOut.minimumInteritemSpacing = 0
        flowOut.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowOut)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.isPagingEnabled = true
        //        collectionView.
        
        collectionView.register(CommonAlumCollectionViewCell.self, forCellWithReuseIdentifier: CommonAlumCollectionViewCellID)
        //
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }else {
            //            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionView.zf_scrollViewDirection = ZFPlayerScrollViewDirection.horizontal
        
        
        return collectionView
    }()
    
    var playerController:CommonPlayerController {
        if self == devicePhotoBrowser {
            return LivePlayerControllerManager.shared.playerController
        }else {
            return ZFAVPlayControllerManager.shared.playerController
        }
    }
    
    weak var localDataHelper:LocalPhotoDataHelper? {
        didSet{
            localDataHelper?.addDataObserver(self)
        }
    }
    private var allNeedFetchIndexPaths = [IndexPath]()
    //    MARK: - init method -
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureSubviews()
        
        let panGestrue = UIPanGestureRecognizer.init(target: self, action: #selector(viewIsPanned(sender:)))
        panGestrue.maximumNumberOfTouches = 1
        addGestureRecognizer(panGestrue)
        
    }
    
    
    private func configureSubviews() -> () {
        
        backgroundColor = UIColor.init(white: 1, alpha: 0)
        addSubview(collectionView)
//        addSubview(placeHolderImageView)
        addSubview(navigationBar)
        navigationBar.addSubview(cancelButton)
        navigationBar.addSubview(titleLabel)
        navigationBar.addSubview(promptLabel)
        navigationBar.addSubview(deleteButton)
        
//        collectionView.mas_makeConstraints { (make) in
//            make?.edges.equalTo()(self)
//        }
        
        navigationBar.mas_makeConstraints { (make) in
            make?.top.left()?.right()?.equalTo()(self)
            make?.height.mas_equalTo()(StatusBarH + NavigationBarH)
        }
        
        cancelButton.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(15)
            make?.height.mas_equalTo()(NavigationBarH)
            make?.width.equalTo()(40)
            make?.centerY.equalTo()(self.mas_top)?.offset()(StatusBarH + NavigationBarH/2)
        }
        
        deleteButton.sizeToFit()
        deleteButton.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-15)
            make?.centerY.equalTo()(self.mas_top)?.offset()(StatusBarH + NavigationBarH/2)
        }
        
        titleLabel.sizeToFit()
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.bottom.equalTo()(self.mas_top)?.offset()(StatusBarH + NavigationBarH/2)
        }
        
        promptLabel.sizeToFit()
        promptLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self.mas_top)?.offset()(StatusBarH + NavigationBarH/2)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func showLocalAlbum(on containerView:UIView,animated:Bool,startRect:CGRect,album:LocalPhotosDataManager.AlbumType,selectedIndexPath:IndexPath)->(){
        
        localPhotoBrowser.configureToShow(on: keyWindow, animated: true, startRect: startRect, albumFrow: album.rawValue, selectedIndexPath: selectedIndexPath)
        ZFAVPlayControllerManager.shared.playerController.isViewControllerDisappear = false
    }
    
    
    class func showDeviceAlbum(on containerView:UIView,animated:Bool,startRect:CGRect,albumSource:String,selectedIndexPath:IndexPath)->(){
        devicePhotoBrowser.deviceSectionModels = DevicePhotoDataHelper.shared.albumsSectionModels[DevicePhotoAlbum.init(rawValue: albumSource)!]?.copy() ?? []
        
        devicePhotoBrowser.configureToShow(on: keyWindow, animated: true, startRect: startRect, albumFrow: albumSource, selectedIndexPath: selectedIndexPath)
        //        sharedDevice.models = models
        let playContainView = ZFPlayerScrollViewCellInfo.init(scrollView: devicePhotoBrowser.collectionView, containerTag: CommonAlumCollectionViewCell.playContainerViewTag)
        LivePlayerControllerManager.shared.set(scrollViewInfo: playContainView, models: devicePhotoBrowser.models)
        LivePlayerControllerManager.shared.playerController.disableGestureTypes = [.pan,.pinch]
        LivePlayerControllerManager.shared.playerController.isViewControllerDisappear = false
        devicePhotoBrowser.configureDeviceAutoPlay(at: selectedIndexPath)
        
        devicePhotoBrowser.notiObservrations.append(NotificationCenter.default.addObserver(forName: NSNotification.Name.DevicesInfo.websocketDisconnect, object: nil, queue: nil) { (noti) in
            devicePhotoBrowser.hide(animated: false)
        })
        
        DevicePhotoDataHelper.shared.addDataObserver(devicePhotoBrowser)
    }
    
    
    
    func configureToShow(on containerView:UIView,animated:Bool,startRect:CGRect,albumFrow:String,selectedIndexPath:IndexPath) -> () {
        
        backgroundColor = UIColor.init(white: 1, alpha: 0)
        isShowing = true
        photoFrom = albumFrow
        frame = containerView.bounds
        self.startRect = startRect
        collectionView.isHidden = false
        collectionView.frame = containerView.bounds
        collectionView.transform = CGAffineTransform.init(scaleX: startRect.width/containerView.bounds.width, y: startRect.height/containerView.bounds.height)
        collectionView.reloadData()
        //之所以使用transform，是基于两个原因：
        //1.必须要frame正确之后再调用scrollToItem。如果frame改变之前scrollToItem，在frame改变之后位置会异常；
        //2.如果是使用frame，动画效果是frame变成containerView.bounds。根据第1点，只能在动画过程中或者结束之后调用scrollToItem；如果是过程中会有一个突兀的跳动，如果是结束之后则会有一个cell移动，都不是很理想；
        collectionView.scrollToItem(at:selectedIndexPath, at: .left, animated: false)
        shouldShowBar = true
        containerView.addSubview(self)
        
        layoutIfNeeded()
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            self.collectionView.transform = .identity
            self.promptLabel.text = self.models[selectedIndexPath].creationDate?.toString(format: .yyyy_mm_dd)
            self.updateBGColorWhenShowStateChange(UIColor.init(white: 1, alpha: 1))
            self.layoutIfNeeded()
            
        }, completion: { (success) in
            if success {
                self.caculateLocalAlbumPrefetchIndexPaths()
                self.shouldFetchLocalAlbumAssets()
                self.collectionView.isHidden = false
            }
        })
    }
    
    func hide(animated: Bool) -> () {
       
        func videoPlayAndDataManage() {
            self.models.performActionOnAllItems(block: { (item) in
                var newItem = item
                newItem.isThumbnailImage = true
                return newItem
            })
            self.isShowing = false
            NotificationCenter.default.post(name: Notification.Name.photoBrowser.hidden, object: self)
            
            if self == devicePhotoBrowser {
                LivePlayerControllerManager.shared.playerController.isViewControllerDisappear = true
                LivePlayerControllerManager.shared.stopAndClearPlaySetting()
                self.notiObservrations.removeAll()
                DevicePhotoDataHelper.shared.removeDataObserver(devicePhotoBrowser)
                self.deletedDeviceModels.removeAll()
            }else {
                ZFAVPlayControllerManager.shared.playerController.isViewControllerDisappear = true
                self.localDataHelper?.removeDataObserver(self)
            }
        }
        
        if animated == false {
            self.removeFromSuperview()
            self.isShowing = false
            videoPlayAndDataManage()
        } else {
            let finalTransform = CGAffineTransform.init(translationX: (startRect.midX - ScreenW/2), y: (startRect.midY - ScreenH/2)).scaledBy(x: startRect.width/collectionView.frame.width, y: startRect.height/collectionView.frame.height)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.collectionView.transform = finalTransform
                self.updateBGColorWhenShowStateChange(UIColor.init(white: 1, alpha: 0))
                self.layoutIfNeeded()
            }, completion: { [unowned self] (success)in
                self.collectionView.isHidden = true
                self.collectionView.transform = CGAffineTransform.identity
                self.removeFromSuperview()
                videoPlayAndDataManage()
            })
        }
    }
    
    

    //    MARK: - target action -
    
    @objc func viewIsTapped(sender:NSObject) -> () {
        
        if sender == cancelButton {
//            self.changeView(playStated: false)
            if self == devicePhotoBrowser {

            }else {
                ZFAVPlayControllerManager.shared.stopPlayVedio()
            }
            hide(animated: true)
            
        } else if sender == deleteButton {
            
            if collectionView.indexPathsForVisibleItems.count > 0 {
                let indexPath = collectionView.indexPathsForVisibleItems[0]
                let currentModel = models[indexPath]
                
                CommonAlertController.common_presentAlertDefaultOnScreen(animated: true, title: "删除文件".localized, message: "文件删除后将无法找回，确定删除？".localized,confirmTitle:"确认".localized, confirmHandler: { (actionInfo) in
                    if let currentLocalModel = currentModel as? CommonAlbumItemModel {
                        ProgressHUD.showLoadingDataHUD(on: keyWindow, animated: true)
                        
                        LocalPhotosDataManager.shared.deletePhotos([currentLocalModel], in: nil) { (success, error, info) in
                            DispatchQueue.main.async {  [unowned self] in
                                if success {
                                    
                                    self.models.removeItem(at:indexPath)
                                    
                                    if self.models[indexPath.section].items.count == 0 {
                                        self.models.clearEmptyItemModels()
                                        self.collectionView.deleteSections([indexPath.section])
                                    }else {
                                        self.collectionView.deleteItems(at: [indexPath])
                                    }
                                    
                                    self.changePromptLabelState()
                                    
                                    CommonPromptHUD.showInfo( "删除成功".localized,orientationMatchScreen: true)
                                    
                                }else if let tError = error {
                                    CommonPromptHUD.showError( "删除失败！".localized + ErrorCodeTool.codeSuffix(tError),orientationMatchScreen: true)
                                }
                                ProgressHUD.hideHUD(animated: true)
                            }
                        }
                        
                    }else if let currentModel = currentModel as? CommonNetAlbumItemModel {
                        
                        if self.deletedDeviceModels.contains(where: { $0.mediaID == currentModel.mediaID }) {
                            self.deleteDeviceAlbumCellAndUpdateView(at: indexPath)
                        } else {
                            
                            func deletePhotos() {
                                DevicePhotosDataManager.shared.deletePhotos([currentModel.mediaID!],{ [unowned self](success,error,undeleteMediaIDS)in
                                    if success {
                                        
                                        self.deleteDeviceAlbumCellAndUpdateView(at: indexPath)
                                        DevicePhotoDataHelper.shared.shouldDelete(models: [currentModel], for: DevicePhotoAlbum.init(rawValue: self.photoFrom)!)
                                        DevicePhotosDataManager.shared.albumDownloadInfo.cancelManageModels([currentModel.mediaID!])
                                    } else if let theError = error {
                                        CommonPromptHUD.showError( String.CommonLocal.getDataFailed   + ErrorCodeTool.codeSuffix(theError),orientationMatchScreen: true)
                                    }
                                    self.collectionView.zf_filterShouldPlayCellWhileScrolled { [unowned self](indexPath) in
                                        self.deviceAlbumShouldPlay(at: indexPath)
                                    }
                                    ProgressHUD.hideHUD(animated: true  )
                                })
                            }
                            
                            ProgressHUD.showLoadingDataHUD(animated: true)
                            if currentModel.isVedio {
                                self.playerController.needSafeExcuteAfterStop = {
                                   deletePhotos()
                                }
                                self.playerController.stopCurrentPlayingCell()
                            } else {
                                self.collectionView.zf_playingIndexPath = nil
                                (self.collectionView.cellForItem(at: indexPath) as! CommonAlumCollectionViewCell).contentImageView.sd_cancelCurrentImageLoad()
                                deletePhotos()
                            }
                        }
                    }
                })
            }
        }
}
 
    private func configureDeviceAutoPlay(at selectedIndexPath:IndexPath) -> () {
        collectionView.zf_scrollViewDidStopScrollCallback = { (IndexPath) in
            devicePhotoBrowser.deviceAlbumShouldPlay(at: IndexPath)
        }
        //默认是false，在手机有蜂窝网络时，不会自动播放；
        collectionView.zf_isWWANAutoPlay = true
        deviceAlbumShouldPlay(at: selectedIndexPath)
    }
    
    func deleteDeviceAlbumCellAndUpdateView(at indexPath:IndexPath) -> () {
        models.removeItem(at: indexPath)
        collectionView.deleteItems(at: [indexPath])
        if models[indexPath.section].items.count == 0 {
            models.clearEmptyItemModels()
            collectionView.deleteSections(IndexSet([indexPath.section]))
        }
        changePromptLabelState()
        if var  sectionAssetUrls = playerController.sectionAssetURLs {
            var sectionUrls = sectionAssetUrls[indexPath.section]
            sectionUrls.remove(at: indexPath.row)
            if sectionUrls.count == 0 {
                sectionAssetUrls.remove(at: indexPath.section)
            }else {
                sectionAssetUrls.replaceSubrange(indexPath.section...indexPath.section, with: [sectionUrls])
                print_Debug(message: "")
            }
            playerController.sectionAssetURLs = sectionAssetUrls
        }
        
    }
    
    @objc func viewIsPanned(sender:UIPanGestureRecognizer) -> () {
        
        let translation = sender.translation(in: self)
        
        switch sender.state {
        case .began:
            if self == localPhotoBrowser {
                ZFAVPlayControllerManager.shared.stopPlayVedio()
            }
                        
            collectionView.transform = CGAffineTransform.init(translationX: translation.x, y: translation.y)
            let transformColor = UIColor.init(white: 1, alpha: 1 - 2/ScreenH * translation.y)
            updateBGColorWhenShowStateChange(transformColor)
        case .changed:
            collectionView.transform = CGAffineTransform.init(translationX: translation.x, y: translation.y)
            let transformColor = UIColor.init(white: 1, alpha: 1 - 2/ScreenH * translation.y)
            updateBGColorWhenShowStateChange(transformColor)
        case .ended:
            if translation.y > 100 || translation.y < -100 {
                hide(animated: true)
            } else {
                UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                    self.collectionView.transform = CGAffineTransform.identity
                    self.updateBGColorWhenShowStateChange( UIColor.init(white: 1, alpha: 1))
                }) { (success) in
                }
            }
        case .cancelled:
            collectionView.transform = CGAffineTransform.identity
           updateBGColorWhenShowStateChange( UIColor.init(white: 1, alpha: 1))
        default:
            print_Debug(message: "view Is panned ,pan translate=\(translation) status=\(sender.state)")
        }
    }
    
    private func updateBGColorWhenShowStateChange(_ newColor:UIColor) -> (){
        backgroundColor = newColor
        navigationBar.backgroundColor = newColor
    }
    
    
  
    //    MARK: - zfplayer scrollview  && deta load (generic cannot extension delegate) -

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()

//        print_Debug(message: "scrollViewDidEndDecelerating ,collectionView.visibleCells.count=\(collectionView.visibleCells.count),indexpath=\(String(describing: collectionView.indexPathForItem(at: scrollView.contentOffset)))")
        changePromptLabelState()
    }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()

        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.count > 0 {
            
            if  self == localPhotoBrowser {
                collectionView.reloadItems(at: [indexPath])
                ZFAVPlayControllerManager.shared.stopPlayVedio()
            }else{
//                print_Debug(message: "scrollViewWillBeginDragging")
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
        if self == devicePhotoBrowser {
//            print_Debug(message: "scrollViewDidEndDragging,willDecelerate" )
        }
        changePromptLabelState()
        shouldFetchLocalAlbumAssets()
        
    }
        
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
        if self == devicePhotoBrowser {
            print_Debug(message: "scrollViewDidScroll" )
//            解决从图片切换到视频时，视频不会自动播放的问题；因ZFPlayer默认都是视频，所以早图片拖动时无法设置zf_playingIndexPath为nil，导致scrollDidStoppedCallBack{}中的indexPath有误；
            if let curPlayingIndexPath = scrollView.zf_playingIndexPath,
                let currentModel = models[curPlayingIndexPath] as? CommonNetAlbumItemModel,
                currentModel.isVedio == false {
                scrollView.zf_playingIndexPath = nil
            }
        }
    }
    
    private func changePromptLabelState() -> () {
        
        if collectionView.indexPathsForVisibleItems.count > 0 {
            var finalIndexPath:IndexPath
            if collectionView.indexPathsForVisibleItems.count == 1 {
                finalIndexPath = collectionView.indexPathsForVisibleItems[0]
            }else {
                let sortedIndexPath = collectionView.indexPathsForVisibleItems.sorted()
                
                if collectionView.zf_scrollDirection == .left {
                    finalIndexPath = sortedIndexPath.last!
                } else {
                    finalIndexPath = sortedIndexPath.first!
                }
            }
            promptLabel.text = models[finalIndexPath].creationDate?.toString(format: .yyyy_mm_dd)
            
//            print_Debug(message: "changePromptLabelState indexPathsForVisibleItems indexPaths =\(collectionView.indexPathsForVisibleItems),collectionView.zf_scrollViewDirection=\(collectionView.zf_scrollDirection.rawValue),finalIndexPath=\(finalIndexPath)")
        }
    }
    
    func deviceAlbumShouldPlay(at indexPath:IndexPath) -> () {
        if let model = models[indexPath] as? CommonNetAlbumItemModel,model.isVedio,
            let indexInfo = models.firstInfo(where: { $0 == model.mediaID }) {
            if deletedDeviceModels.contains(where: { $0.mediaID == model.mediaID }) {
                CommonPromptHUD.showError("资源已不存在".localized,orientationMatchScreen: true)
                deleteDeviceAlbumCellAndUpdateView(at: indexInfo.location)
                collectionView.zf_filterShouldPlayCellWhileScrolled { [unowned  self](indexPath) in
                    self.playerController.playTheIndexPath(indexPath, scrollToTop: false)
                }
            }else {
                UserBehaviorStatisticsManager.shared.trackCustomEvent(.deviceAlbumVideoPlay, errorInfo: nil, additionalPara: [UBStatisticsParameter.videoNumber.rawValue:model.mediaID!])
                LivePlayerControllerManager.shared.playerController.playTheIndexPath(indexPath, scrollToTop: false)
//                print_Debug(message: "LivePlayerControllerManager play the indexPath=\(indexPath)")
            }
        }
    }
    
    // MARK: - collectionView delegage datasource -
      
      func numberOfSections(in collectionView: UICollectionView) -> Int {
          return models.count
      }
      
      
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return models[section].items.count
      }
      
      
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonAlumCollectionViewCellID, for: indexPath) as! CommonAlumCollectionViewCell
          
          let model = models[indexPath]
          cell.model = model
          cell.controlIsTapped = { (control,event) in
              
              if control.viewDescribe() == CommonAlumCollectionViewCell.controlType.play.rawValue {
                  
                  if let model = cell.model as? CommonAlbumItemModel {
                      ProgressHUD.showLoadingDataHUD(on: keyWindow, animated: true)
                      control.isHidden = true
                      LocalPhotosDataManager.shared.getAvasset(for: model.phasset, complete: { (avasset, error, info) in
                          
                          let date = model.creationDate ?? Date.init(timeIntervalSinceNow: 0)
                          let dateFormatter = DateFormatter.init()
                          dateFormatter.dateFormat = "yyyyMMddHHmmss"
                          
                        DispatchQueue.main.sync {
                            if let trAvasset = avasset as? AVURLAsset {
                                ZFAVPlayControllerManager.shared.play(avAsset: trAvasset, on: collectionView,viewTag:cell.contentImageView.tag,indexPath:indexPath)
                                ZFAVPlayControllerManager.shared.playToEnd = { [unowned self] in
                                    control.isHidden = false
                                    self.playerController.currentPlayerManager.replay?()
                                }
                                
                                UserBehaviorStatisticsManager.shared.trackCustomEvent(.localAlbumVideoPlay, errorInfo: nil, additionalPara: [UBStatisticsParameter.videoNumber.rawValue:dateFormatter.string(from: date)])
                            }else {
                                UserBehaviorStatisticsManager.shared.trackCustomEvent(.localAlbumVideoPlay, errorInfo: "从系统相册加载数据出错,\(error)", additionalPara: [UBStatisticsParameter.videoNumber.rawValue:dateFormatter.string(from: date)])
                            }
                            control.isHidden = false
                            ProgressHUD.hideHUD(animated: true)
                        }
                      })
                  }
              }
          }
          
          return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          var size = bounds.size
          size.height = ScreenH - StatusBarH - SafeBottomMargin - NavigationBarH
          return size
      }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
           caculateLocalAlbumPrefetchIndexPaths()
        
    }
    
    private func caculateLocalAlbumPrefetchIndexPaths() {
        if self == localPhotoBrowser {
            let currentOriginPoint = collectionView.visibleCells[0].frame.origin
            var needFetchIndexPaths = [IndexPath]()
            for loca in -2..<2 {
                let point = CGPoint.init(x: currentOriginPoint.x + CGFloat(loca) * ScreenW, y: currentOriginPoint.y)
                if let indexPath = collectionView.indexPathForItem(at: point) {
                    needFetchIndexPaths.append(indexPath)
                }
            }
//            print_Debug(message: "needFetchIndexPaths=\(needFetchIndexPaths)")
            allNeedFetchIndexPaths = needFetchIndexPaths
        }
    }
    
    private func shouldFetchLocalAlbumAssets() -> () {
        if self == localPhotoBrowser {
            var targetAssets = [PHAsset]()
            allNeedFetchIndexPaths.forEach { (indexPath) in
                targetAssets.append((models as! [CommonAlbumSectionModel<CommonAlbumItemModel>])[indexPath].phasset)
            }
            localDataHelper?.setCurrentNeedFetchAssets(targetAssets)
//            print_Debug(message: "scrollViewDidEndDragging,willDecelerate,targetAssets.count=\(targetAssets.count)" )
        }
    }
      
    
}

//MARK:- local data observe -
extension PhotoBrowserView:PhotoDataChanged {
    
    func storeHighQualityImage(for phasset: PHAsset) {
        if let visiaCells = collectionView.visibleCells as? [CommonAlumCollectionViewCell] {
            if let fitCell = visiaCells.first(where: { ($0.model as! CommonAlbumItemModel).phasset.localIdentifier == phasset.localIdentifier }) {
                fitCell.setHighQualityContentImage()
            }
        }
    }
    
}

//MARK:- device data observe -
extension PhotoBrowserView:AlbumsDataObserver {
    
    func mediasCountWillChanged(with updateInfo: DeviceAlbumEditInfo, for album: DevicePhotoAlbum, editType: EditType) {
        guard album.rawValue == photoFrom, self == devicePhotoBrowser else {
            return
        }
    }
    
//    方案：浏览图的models与DeviceAlbumController里面分开，因为自动删除、增加会导致当前视频播放停止；
    func mediasCountDidChanged(with updateInfo: DeviceAlbumEditInfo, for album: DevicePhotoAlbum, editType: EditType) {
        guard album.rawValue == photoFrom, self == devicePhotoBrowser else {
            return
        }

// 当播放视频的时候，在collectionView前面增加项目的时候，播放的cell会自动后移，导致播放停止；暂时没办法解决这个问题
// 最终方案：为了不影响用户浏览视频、图片，本视图在浏览时不再能够增加/删除项目，
                switch editType {
                case .add:

                    break
                case .delete:
                    if let deletedModels = updateInfo.changedAlbumModels {
                        deletedDeviceModels.append(contentsOf: deletedModels )
//                        print_Debug(message: "PhotoBrowserView deletedModels added,deletedModels.count =\(deletedDeviceModels.count)")
                    }
//                    print_Debug(message: "PhotoBrowserView delete rows=\(updateInfo.updateRows),sections=\(updateInfo.updateSections)")

                default:
                    fatalError("genneral not have to replace")
                }
//            }
            
//        }
    }
    
    func mediasInfoUpdate(infos: [DeviceAlbumUpdateInfo]) {

    }
        
    
}


extension Notification.Name {
    
    struct photoBrowser {
        static let hidden = Notification.Name.init("PhotoBrowserView hides")
    }
    
}
