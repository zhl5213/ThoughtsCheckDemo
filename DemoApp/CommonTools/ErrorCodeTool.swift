//
//  ErrorCodeTool.swift
//  MiniEye
//
//  Created by user_ on 2019/7/10.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

import UIKit
import Alamofire
import Starscream

protocol CodedError:Error {}

extension NSError:CodedError {}
extension AFError:CodedError {}
extension CFNetworkErrors:CodedError{}
extension URLError:CodedError{}

class ErrorCodeTool: NSObject {
    
    static func codeSuffix(_ error:CodedError) -> String {
        var code:Int
        var errorDomain:String?
        
        if let tError = error as? NetworkServiceError {
            switch tError {
            case .responseEmpty:
                code = 60001
            case .decodeResponseStringFailure(let statusCode):
                if let tStatusCode = statusCode {
                    code = tStatusCode
                } else {
                    code = 60002
                }
            case .deserilizeResponseFailure(let statusCode):
                if let tStatusCode = statusCode {
                    code = tStatusCode
                } else {
                    code = 60003
                }
            case .unlogin:
                code = 60004
            case .encodeDataError:
                code = 60005
            case .sessionError:
                code = 60006
            case .needResumeError:
                code = 60007
            case .notFound:
                code = 60008
            case .thirdPartyUnkownError(let error):
                if let tError = error as NSError? {
                    code = tError.code
                    errorDomain = tError.domain
                } else {
                    code  =  60009
                }
            case .other(code:let netCode, message: _):
                code = netCode ?? 60010
            case .websocketDisconnect:
                code = 60011
            }
            errorDomain = "\(tError)"
        } else if let tError = error as? NetError {
            code = tError.rawValue
        }else if let tError = error as? DeviceServerError {
            code = tError.rawValue
        }else if let urlError = error as? URLError{
            code = urlError.code.rawValue
        }else if let tError = error as? CFNetworkErrors {
            code = Int(tError.rawValue)
            //            https://developer.apple.com/documentation/cfnetwork/cfnetworkerrors
//            https://developer.apple.com/documentation/foundation/1448136-nserror_codes
//            kCFURLErrorUnknown   = -998,
//            kCFURLErrorCancelled = -999,
//            kCFURLErrorBadURL    = -1000,
//            kCFURLErrorTimedOut  = -1001,
//            kCFURLErrorUnsupportedURL = -1002,
//            kCFURLErrorCannotFindHost = -1003,
//            kCFURLErrorCannotConnectToHost    = -1004,
//            kCFURLErrorNetworkConnectionLost  = -1005,
//            kCFURLErrorDNSLookupFailed        = -1006,
//            kCFURLErrorHTTPTooManyRedirects   = -1007,
//            kCFURLErrorResourceUnavailable    = -1008,
//            kCFURLErrorNotConnectedToInternet = -1009,
//            kCFURLErrorRedirectToNonExistentLocation = -1010,
//            kCFURLErrorBadServerResponse             = -1011,
//            kCFURLErrorUserCancelledAuthentication   = -1012,
//            kCFURLErrorUserAuthenticationRequired    = -1013,
//            kCFURLErrorZeroByteResource        = -1014,
//            kCFURLErrorCannotDecodeRawData     = -1015,
//            kCFURLErrorCannotDecodeContentData = -1016,
//            kCFURLErrorCannotParseResponse     = -1017,
//            kCFURLErrorInternationalRoamingOff = -1018,
//            kCFURLErrorCallIsActive               = -1019,
//            kCFURLErrorDataNotAllowed             = -1020,
//            kCFURLErrorRequestBodyStreamExhausted = -1021,
//            kCFURLErrorFileDoesNotExist           = -1100,
//            kCFURLErrorFileIsDirectory            = -1101,
//            kCFURLErrorNoPermissionsToReadFile    = -1102,
//            kCFURLErrorDataLengthExceedsMaximum   = -1103,
        }else if let tError = error as? AFError {
            switch tError {
                case .invalidURL(url: _):
                code = 61000
                errorDomain = "\(tError)"
            case .multipartEncodingFailed(reason: _):
                code = 61001
                errorDomain = "\(tError)"
            case .parameterEncodingFailed(reason: _):
                code = 61002
                errorDomain = "\(tError)"
        //json格式不对或者数值为空，会报这个错误；
            case .responseSerializationFailed(reason: _):
                code = 61003
                errorDomain = "\(tError)"
        //状态码不在设计范围内，或者内容不在可接受范围内等会报这个错误；
            case .responseValidationFailed(reason: _):
                code = 61004
                errorDomain = "\(tError)"
            }
        }else if let tError = error as? WebsocketError {
            switch tError {
            case .connectFailed(originError: let originError):
                var errorType:Starscream.ErrorType?
                if let wsError = originError as? Starscream.WSError {
                    errorType = wsError.type
                }else if let oError = originError as? Starscream.ErrorType {
                    errorType = oError
                }
                
                if let tErrorType = errorType {
                    switch tErrorType {
                    case .closeError:
                        code = 62000
                    case .compressionError:
                        code = 62001
                    case .invalidSSLError:
                        code = 62002
                    case .outputStreamWriteError:
                        code = 62003
                    case .protocolError:
                        code = 62004
                    case .upgradeError:
                        code = 62005
                    case .writeTimeoutError:
                        code = 62006
                    }
                    errorDomain = (tErrorType as NSError).domain
                }else {
                    code = 62007
                }
            }
            
        }else if let tError = error as? LoadAssetError {
            switch tError {
            case .failed(let error):
                if let tError = error as NSError? {
                    code = tError.code
                    errorDomain = tError.domain
                } else {
                    code = 70000
                }
            case .isNotPlayable:
                code = 70001
            case .hasProtectedContent:
                code = 70002
            }
        }else if let tError = error as? CompositeAssetError {
            switch tError {
            case .exportedFail(let trError):
                if let trError = trError {
                    code = (trError as NSError).code
                    errorDomain = (trError as NSError).domain
                } else {
                     code = 70002
                }
            case .noVedioTrack:
                code = 70003
            }
        }else if let tError = error as? AuthorizationError {
            switch tError {
            case .alreadyRefuse:
                code = 70100
            case .denied:
                code = 70101
            case .notDeterminedToRefuse:
                code = 70102
            case .otherUnkownReason:
                code = 70103
            case  .systemReason:
                code = 70104
            case .userNotDetermin:
                code = 70105
            }
        }else if let tError = error as? PHLError {
            switch tError {
            case .authorizationFailed:
                code = 70200
            case .createAlbumFail(let nsError as NSError):
                code = nsError.code
                errorDomain = nsError.domain
            case .createAssetFailed:
                code = 70202
            case .deleteAssetsFail:
                code = 70203
            case  .requestAssetError:
                code =  70204
            case .requestImageInfosNotComplete:
                code = 70205
            case .saveAssetFailed:
                code = 70206
            case .imageSizeNotFit:
                code = 70207
            case .mediaTypeWrong:
                code = 70208
            case .noThatCollection:
                code = 70209
            case .notAuthorization:
                code = 70210
            case .notValidMedias:
                code = 70211
            case .unknown(let nsError):
                if let tNSError = nsError as NSError? {
                    code = tNSError.code
                    errorDomain = tNSError.domain
                }else {
                    code = 70207
                }
            }
        }else if let tError = error as? FileError {
            switch tError {
            case .canNotEnumerator:
                code = 70300
            case .fileNotExsit:
                code = 70301
            case .getFileContentFailed:
                code = 70302
            case .writeToFileFailed:
                code = 70303
            }
        }else if let tError = error as? FileError.CreateDirctory {
            switch tError {
            case .DirectoryAlreadyExsit:
                code = 70310
            case .isNotFileUrl:
                code = 70311
            case .createFailed:
                code = 70312
            }
        } else{
            code = (error as NSError).code
        }
        
        if errorDomain == nil {
            errorDomain = (error as NSError).domain
        }
        
        return "Error code = " + "(\(code))," + "ErrorDomain = \(errorDomain!)"
    }
    
    enum NetError:Int, CodedError {
        
       
        case unbindPhone        = 20223   //: "微信注册/登录成功，但用户未绑定手机"
        case hasBindPhone       = 20224   //: "该手机已经绑定了其他微信"
        case invalidUrl         = 40000   //: invalid_url
        case dataError          = 40005   //: '数据输入有误'
        case dataInvalid        = 40006   //: '数据输入无效，缺乏有效信息'
        case dataFormateError   = 40007   //: '数据格式有误'
        case phoneNunmberError  = 40021   //: '手机号码格式不正确'
        case loginError         = 40031   //: '用户名或密码错误'
        case SMCError           = 40032   //: '验证码错误, 请重新输入'
        case SMCEexpired        = 40033   //: '验证码已经过期，请重新申请'
        case SMCReSent          = 40034   //: '请重新申请验证码'
        case SMCTooOften        = 40035   //: '申请验证码间隔太频繁，请稍后再试'
        case SMCLimited         = 40036   //: '当前申请验证码次数已经达到上限'
        case pwdSame            = 40037   //: '新密码与旧密码一样'
        case phoneBinded        = 40039   //: '该邮箱或手机已被绑定'
        case WXBinded           = 40040   //: '该微信已经被其他账户绑定, 如果要改绑到当前账号，需要先注销另一账户的微信授权'
        case WXException        = 40041   //: '当前用户微信账户异常，无法继续注销其授权'
        case authError          = 40055   //: '注册授权验证码错误'
        case pwdNull            = 40060   //: '该账号尚未开通用户名密码登录的模式'
        case WXNull             = 40061   //: '微信尚未注册'
        case needLogin          = 401     //: '用户未登录'
        case loginNull          = 40100   //: '用户未登录'
        case userInexist        = 40101   //: '用户不存在'
        case sessionError       = 40102   //: '登录凭证已经过期，请重新登录'
        case linkEexpired       = 40104   //: '授权链接失效'
        case accountCanceled    = 40144   //: '账户已注销, 如有问题，请联系管理员'
        case permissionDenied   = 40300   //: '用户权限不足'
        case WXAuthFailure      = 50201   //: '微信第三方登录授权失败，获取RefreshToken失败'
        case WXRefreshError     = 50202   //: '微信第三方登录授权失败，获取RefreshToken异常'
        case WXAccessError      = 50203   //: '微信第三方登录授权失败，获取AccessToken失败'
        case paramNull          = 10000   //:  参数为空

        func description() -> String {
            switch self {
                
            case .unbindPhone:
                return "微信注册/登录成功，但用户未绑定手机"
            case .hasBindPhone:
                return "该手机已经绑定了其他微信"
            case .invalidUrl:
                return "地址无效"
            case .dataError:
                return "数据输入有误"
            case .dataInvalid:
                return "数据输入无效，缺乏有效信息"
            case .dataFormateError:
                return "数据格式有误"
            case .phoneNunmberError:
                return "手机号码格式不正确"
            case .loginError:
                return "用户名或密码错误"
            case .SMCError:
                return "验证码错误, 请重新输入"
            case .SMCEexpired:
                return "验证码已经过期，请重新申请"
            case .SMCReSent:
                return "请重新申请验证码"
            case .SMCTooOften:
                return "申请验证码间隔太频繁，请稍后再试"
            case .SMCLimited:
                return "当前申请验证码次数已经达到上限"
            case .pwdSame:
                return "新密码与旧密码一样"
            case .phoneBinded:
                return "该手机已被绑定"
            case .WXBinded:
                return "该微信已经被其他账户绑定, 如果要改绑到当前账号，需要先注销另一账户的微信授权"
            case .WXException:
                return "当前用户微信账户异常，无法继续注销其授权"
            case .authError:
                return "注册授权验证码错误"
            case .pwdNull:
                return "该账号尚未开通用户名密码登录的模式"
            case .WXNull:
                return "微信尚未注册"
            case .needLogin,.loginNull:
                return "用户未登录"
            case .userInexist:
                return "用户不存在"
            case .sessionError:
                return "登录凭证已经过期，请重新登录"
            case .linkEexpired:
                return "授权链接失效"
            case .accountCanceled:
                return "账户已注销, 如有问题，请联系管理员"
            case .permissionDenied:
                return "用户权限不足"
            case .WXAuthFailure:
                return "微信第三方登录授权失败，获取RefreshToken失败"
            case .WXRefreshError:
                return "微信第三方登录授权失败，获取RefreshToken异常"
            case .WXAccessError:
                return "微信第三方登录授权失败，获取AccessToken失败"
            case .paramNull:
                return "参数为空"

            }
        }
    }
    
    enum DeviceServerError:Int,CodedError {
        
        case serverExcuteError             = 50000   //: 服务器内部处理出错
        case dataInputError                = 50001   //: 数据输入有误
        case sendDataToMonitorError        = 50002   //: 发送数据给显示器出错
        case receiveDataFromMonitorError   = 50003   //: 从显示器接收数据出错
        case monitorExcuteError            = 50004   //: 显示器内部处理出错
        case calcMD5Error                  = 50005   //: 计算MD5出错
        case fullStorageError              = 50006   //: "full storage" （服务器容量不足）
        case accessDatabaseError           = 50007   //: 50007: ErrAccessDatabase 访问数据库出错
        case SDCardError                   = 50008   //: "sd card error" （存储卡异常）
        case embedError                    = 50009   //: ErrEmbed 调用嵌入式接口出错
        case upgradingError                = 50010   //: 服务器正在升级，禁止访问
        case upgradeSignatureError         = 51000   //: ErrUpgradeSignature 安装包签名验证失败
        case savePacketError               = 51001   //: ErrSavePackage 保存安装包失败
        case clientValidCheckError         = 52000   //：授权失败
        case fullAlbumError                = 53000  //：相册容量已满
        case videoRecordStartedError       = 53001   //: 录像已开始
        case videoRecordStoppedError       = 53002   //: 录像已结束
        case videoRecordConflictError      = 53003   //: 录像已结束
        
        case clearAlbumError               = 53004   //53004: ErrClearAlbum 清理相册容量出错
        case autoRecordStoppedError        = 53005   //53005: ErrAutoRecordStopped 自动录像已结束

        
        var localizedDescription: String {
            switch self {
            case .serverExcuteError:
                return "服务器内部处理出错"
            case .dataInputError:
                return "数据输入有误"
            case .sendDataToMonitorError:
                return "发送数据给显示器出错"
            case .receiveDataFromMonitorError:
                return "从显示器接收数据出错"
            case .monitorExcuteError:
                return "显示器内部处理出错"
            case .calcMD5Error:
                return "计算MD5出错"
            case .savePacketError:
                return "保存安装包失败"
            case .clientValidCheckError:
                return "授权失败"
            case .fullAlbumError:
                return "相册容量已满"
            case .videoRecordStartedError:
                return "录像已开始"
            case .videoRecordStoppedError:
                return "录像已结束"
            case .videoRecordConflictError:
                return "主机正在抓取视频"
            case .fullStorageError:
                return "服务器容量不足"
            case .SDCardError:
                return "存储卡异常"
            case .clearAlbumError:
                return "清理相册容量出错"
            case .autoRecordStoppedError:
                return "自动录像已结束"
            case .accessDatabaseError:
                return "访问数据库出错"
            case .embedError:
                return "调用嵌入式接口出错"
            case .upgradingError:
                return "服务器正在升级，禁止访问"
            case .upgradeSignatureError:
                return "安装包签名验证失败"
            }
        }
    }
}

