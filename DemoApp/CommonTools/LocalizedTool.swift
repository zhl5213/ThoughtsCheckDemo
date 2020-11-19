//
//  CountryAndRegionManager.swift
//  MiniEye
//
//  Created by 朱慧林 on 2019/5/28.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit

typealias CountryInfo = (countryName:String,countryCode:String)

struct PlaceInfo {
    var country:String?
    var countryCode:String?
    var province:String?
    var city:String?
    
    func description() -> String {
        var desc = String()
        if let value = country {
            desc += value
        }
        if let value = province {
            desc += " " + value
        }
        if let value = city {
            desc += " " + value
        }
        return desc
    }
}

//MARK: - language localization
public extension LocalizedTool {
    var userLanguageKey: String {
        return "userLanguageKey"
    }
    
    var appleLanguagesKey: String {
        return "AppleLanguages"
    }
    
    enum AppLanguage:String {
        case chinese_simplified = "zh-Hans"
        case chinese_traditional = "zh-Hant"
        case english = "en"
        
        func description() -> String {
            switch self {
            case .chinese_simplified:
                return "简体中文"
            case .chinese_traditional:
                return "繁體中文"
            case .english:
                return "English"
            }
        }
        
        func stringCode() -> String {
            switch self {
            case .chinese_simplified:
                return "zh-hans"
            case .chinese_traditional:
                return "zh-hant"
            case .english:
                return "en"
            }
        }
        
        func localeIdentifier() -> String {
            switch self {
            case .chinese_simplified:
                return "zh_hans"
            case .chinese_traditional:
                return "zh_hant"
            case .english:
                return "en"
            }
        }
    }
    
    func resetSystemLanguage() {
        UserDefaults.standard.removeObject(forKey: userLanguageKey)
        UserDefaults.standard.set(nil, forKey: appleLanguagesKey)
        UserDefaults.standard.synchronize()
        configLanguage()
    }
    
    func setUserLanguage(_ language:String) {
        UserDefaults.standard.set(language, forKey: userLanguageKey)
        UserDefaults.standard.set([language], forKey: appleLanguagesKey)
        UserDefaults.standard.synchronize()
        configLanguage()
    }
    
    func configLanguage() {
        userLanguage = getUserLanguage()
        languageBundle = getLanguageBundle()
    }
    
}

@objcMembers
public class LocalizedTool: BasicTool {
    
    public static let shared = LocalizedTool()
    
    var appLanguages:[AppLanguage] = [.chinese_simplified,.chinese_traditional,.english];

    lazy var languageBundle: Bundle = {
        let bundle = getLanguageBundle()
        return bundle
    }()
    
    lazy var userLanguage: AppLanguage = {
        let lan = getUserLanguage()
        return lan
    }()
    
    func getUserLanguage() -> AppLanguage {
        if let lanStr = UserDefaults.standard.string(forKey: userLanguageKey),let lan = AppLanguage.init(rawValue: lanStr) {
            return lan
        }
        
        let systemLan = UserDefaults.standard.stringArray(forKey: appleLanguagesKey)!.first!
        for lan in LocalizedTool.shared.appLanguages {
            if systemLan.contains(lan.rawValue) {
                return lan
            }
        }
        return AppLanguage.english
    }
    
    func getLanguageBundle() -> Bundle {
        let lan = userLanguage
        if let path = Bundle(for: AppDelegate.self).path(forResource: lan.rawValue, ofType: "lproj") {
            return Bundle(path: path)!
        }
        return Bundle(for: AppDelegate.self)
    }
    
    var currentLocal:NSLocale {
        return NSLocale.init(localeIdentifier: self.userLanguage.localeIdentifier())
    }
    
    var currentCountryName:String? {
        return currentLocal.displayName(forKey: NSLocale.Key.countryCode, value:currentLocal.countryCode as Any)
    }
    
    func chinaName() -> String {
        return currentLocal.displayName(forKey: NSLocale.Key.countryCode, value:chinaCode())!
    }
    
    func chinaCode() -> String {
        return "CN"
    }
    
    func isChina(_ code:String) -> Bool {
        return chinaCode() == code
    }
    
    func chinaCityNames() -> [String] {
        
        let path = Bundle.main.path(forResource: "cityArray", ofType: "plist")!
        let cityAreaNames = NSArray.init(contentsOfFile: path)
        return cityAreaNames as! [String]
    }
    
//    func chinaDistrictName(for cityName:String) -> [String] {
//        var cityAreaNames = [String]()
//        
//        if let namesDic = LocalFileTool.shared.fetchInfoInBundle(fromPlist:"cityData"),namesDic.count > 0 {
//            for (key,value) in namesDic {
//                if key as! String == cityName {
//                    cityAreaNames = value as! [String]
//                }
//            }
//        }
//        return cityAreaNames
//    }
    
    
    func getAllCountryInfos() -> [CountryInfo] {
        
        var countryNames = [CountryInfo]()
        let countryCodes = NSLocale.isoCountryCodes
        let except = ["HK","MO","TW"]
//        countryCodes.removeAll { (ele) -> Bool in
//            return except.contains(ele)
//        }
        for countryCode in countryCodes {
            
            var countryName  = currentLocal.displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
            if except.contains(countryCode) {
                countryName = countryCode
            }
            countryNames.append((countryName!,countryCode))
        }
        
        countryNames.sort { (first, second) -> Bool in
            return first.countryName.localizedCompare(second.countryName) == .orderedAscending
        }
        
       return countryNames
    }
    

}
