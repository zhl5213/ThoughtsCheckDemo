//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

enum StringError:String,Error {
    case emptyEmail = "请输入电子邮箱地址"
    case invalidEmail = "电子邮箱不合法，请检查后重新输入。"
     var localizedDescription:String {
        return rawValue
    }
}

extension String {
    ///单元测试完成。邮件字符串必须是“任意内容@任意内容.2-8位字母”
    static func check(Email:String?)throws  {
        guard let Email = Email,Email.count > 0 else {
            throw StringError.emptyEmail
        }
        
        let pattern = "^(.*)+@(.*)+\\.([A-Za-z]{2,8})$"

        let regulaerEx = try? NSRegularExpression.init(pattern: pattern, options: [])
        if let results = regulaerEx?.matches(in: Email, options: [], range: NSRange.init(location: 0, length: Email.count)),results.count == 0 {
            throw StringError.invalidEmail
        }
    }
    
}

let needTestEmails = ["","21300.@","1231@.","123.com","123@.com","132中文@中文的.com","123@com","jlczldwajo2_-2@11.com.cn"]


for email in needTestEmails {
    if let _ =  try? String.check(Email: email){
        print("\(email) is valid")
    }
//    do {
//        try String.check(Email: email)
//        print("\(email) is valid")
//    } catch {
//        print("\(email) is not valid,error is \(error as! StringError)")
//    }
}









