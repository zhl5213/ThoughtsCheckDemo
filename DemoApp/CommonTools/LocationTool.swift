////
////  LocationTool.swift
////  MiniEye
////
////  Created by 朱慧林 on 2019/5/29.
////  Copyright © 2019 MINIEYE. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//
//typealias locationUpateComplete = (_ success:Bool,_ location:CLLocation?)->()
//typealias locationTransfromComplete = (_ success:Bool,_ error:Error?,_ cityInfo:PlaceInfo?)->()
//typealias authorizationBlock = (_ authorizationed:Bool,_ error:AuthorizationError?)->()
//
//enum AuthorizationError:CodedError {
//    case denied
//    case notDeterminedToRefuse
//    case alreadyRefuse
//    case systemReason
//    case userNotDetermin
//    case otherUnkownReason
//}
//
//class LocationTool: BasicTool {
//    
//    enum infoError:Error {
//        case cityNameEmpty
//    }
//    
//    static let  shared:LocationTool = LocationTool()
//    private lazy var locationManager:CLLocationManager  = {
//        let manager = CLLocationManager.init()
//        manager.allowsBackgroundLocationUpdates = true
//        manager.pausesLocationUpdatesAutomatically = false
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.delegate = self
//        return manager
//    }()
//    private let geoCoder = CLGeocoder.init()
//    private var authorizationComplete:authorizationBlock?
//    private var updateLocationBlock:locationUpateComplete?
//    
//    ///测试完成
//    /// 获取当前CLLocation地理位置信息，该方法考虑了所有用户授权情况的逻辑。
//    ///1.如果没有授权，就请求授权。用户如果同意就拿到location之后回调，如果不同意就返回nil。
//    ///2.如果用户拒绝过授权，会弹出alertController提示用户。如果用户取消就返回你了,如果用户确认， 就跳转到设置界面。在用户设置界面切回App界面之后，重新根据授权状态来判断是否获取地理位置信息进行回调。
//    /// - Parameter complete: 完成回调。
//    func getCurrentLocation(complete:@escaping locationUpateComplete) -> () {
//        
//        requestCLAuthorization() { [unowned self](success, error) in
//            if success {
//                self.getCurrentLocationAsAuthorized(complete: complete)
//            }else if let tError = error {
//                if tError == AuthorizationError.denied {
//                    DispatchQueue.main.async {
//                        
//                        let cancelAction = CommonAlertController.actionInfo.init(title: "取消".localized
//                        , style: .cancel) { (action) in
//                            complete(false,nil)
//                        }
//                        
//                        let confirmAction = CommonAlertController.actionInfo.init(title: "确认".localized
//                        , style: .default) { [unowned self](action) in
//                            NotificationCenter.default.addObserver(self, selector: #selector(LocationTool.willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
//                            self.updateLocationBlock = complete
//                            self.openSettingURL()
//                        }
//                        
//                        CommonAlertController.common_presentAlertOnScreen(animated: true, title: "无法访问地理位置".localized, message: "MINIEYE想在使用的时候访问你的地理位置，以设置你的个人位置信息".localized, actionInfos: [cancelAction,confirmAction])
//                    }
//                } else {
//                    CommonPromptHUD.showError( String.CommonLocal.getDataFailed + ErrorCodeTool.codeSuffix(tError))
//                    complete(false,nil)
//                }
//            }
//        }
//    }
//    
//    @objc private func willEnterForeground(noti:Notification) {
//        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
//        if let updateLocationBlock = updateLocationBlock {
//            switch CLLocationManager.authorizationStatus() {
//            case .authorizedAlways,.authorizedWhenInUse:
//                locationManager.startUpdatingLocation()
//            default:
//                updateLocationBlock(false,nil)
//            }
//        }
////        print_Debug(message: "willEnterForeground,CLLocationManager.authorizationStatus()=\(CLLocationManager.authorizationStatus())")
//    }
//    
//    ///单元测试完成
//    func getCurrentLocationAsAuthorized(complete:@escaping locationUpateComplete)  -> () {
//        locationManager.startUpdatingLocation()
//        updateLocationBlock = complete
//        CLLocationManager.locationServicesEnabled()
//    }
//    
//    
//    ///单元测试完成
//    func transformToCityName(location:CLLocation,complete:@escaping locationTransfromComplete) -> () {
//        
//        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
//            if let trPlaceMarks = placeMarks, trPlaceMarks.count > 0 {
//                let cityMark = trPlaceMarks[0]
//                
//                let country = cityMark.country.wrappedToString()
//                let province = cityMark.administrativeArea.wrappedToString()
//                let cityInfo = cityMark.locality.wrappedToString()
//                let countruCode = cityMark.isoCountryCode.wrappedToString()
//                
//                let placeInfo = PlaceInfo(country:country,countryCode: countruCode,province: province, city: cityInfo)
//                
//                if (country + province + cityInfo).count > 0 {
//                    complete(true,nil,placeInfo)
//                }else{
//                    complete(false,infoError.cityNameEmpty,nil)
//                }
//                print_Debug(message: "cityInfo=\(String(describing: cityInfo)),country=\(String(describing: country)),province=\(province)")
//            }
//        }
//    }
//    
//    ///单元测试完成
//    /// 请求地理位置授权，如果用户没有决定过，就请求授权，并且监听地理位置变化，在地理位置变化后调用complete（此时是异步）；其他都是同步调用；
//    /// - Parameter complete:最后一个回调参数无意义；如果已经授权（无论是用户使用过程还是一直授权都是），第一个参数返回true，其他都是返回no；第二个参数是不授权的原因；
//    func requestCLAuthorization(complete:@escaping authorizationBlock) -> () {
//        excuteSyncSafeOnMainThread {
//            switch CLLocationManager.authorizationStatus() {
//            case .denied:
//                complete(false,AuthorizationError.denied)
//            case .notDetermined:
//                self.locationManager.requestAlwaysAuthorization()
//                self.authorizationComplete = complete
//            case .restricted:
//                complete(false,AuthorizationError.systemReason)
//            case .authorizedAlways,.authorizedWhenInUse:
//                complete(true,nil)
//            @unknown default:
//                complete(false,AuthorizationError.otherUnkownReason)
//            }
//        }
//    }
//    
//}
//
//
//extension LocationTool:CLLocationManagerDelegate {
//    
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        
//        if let trComplete = authorizationComplete {
//            switch status {
//            case .authorizedAlways,.authorizedWhenInUse:
//                trComplete(true,nil)
//            case .restricted:
//                trComplete(false,AuthorizationError.systemReason)
//            case .denied:
//                trComplete(false,AuthorizationError.notDeterminedToRefuse)
//            default:
//                print_Debug(message: "didChangeAuthorization other status=\(status.rawValue) ")
//            }
//        }
////        print_Debug(message: "locationManager didChangeAuthorization status=\(status.rawValue) ")
//
//    }
//    
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        if let trUpdateComplete = updateLocationBlock {
//            trUpdateComplete(true,locations.last)
//            locationManager.stopUpdatingLocation()
//        }
////        print_Debug(message: "locationManager didUpdateLocations =\(locations)")
//    }
//    
//}
