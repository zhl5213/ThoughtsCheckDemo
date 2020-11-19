//: [Previous](@previous)

import Foundation
import UIKit



//结构体-------------------------
struct StructModel {
    var name:String
    var height:CGFloat
    
    func doSomething() -> () {
        print(name + "_" + "\(height)")
    }
}

let structM = StructModel.init(name: "struct", height: 33)
structM.doSomething()



//类-------------------------
class ClassModel:NSObject {
    var name:String = ""
    var height:CGFloat?
    
    override init() {
        super.init()
    }
    
    deinit {}
    
    func doSomething() -> () {
        print(name + "_" + "\(height ?? 0)")
    }
}


let classM = ClassModel.init()
classM.name = "class"
classM.height = 33
classM.doSomething()

let clasM2 = classM
print("clasM2 \(clasM2 === classM ? "point to" : "not point to") to the same object of classM")
if classM == clasM2 {
    print("classM == clasM2")
}else {
    print("classM != clasM2")
}


//枚举-------------------------

enum AEnum:Int {
    case first = 1000
    case second
    
}

let se = AEnum.first
print(se.rawValue)


enum EnumModel:Model{
    
    case oneType(height:CGFloat)
    case anotherType(height:CGFloat)
    
    static var staticName:String = ""
    //计算属性
    var name:String{
        get{
            return EnumModel.staticName
        }
        set{
            EnumModel.staticName = newValue
        }
    }
    
    func doSomething() -> () {
        var height:CGFloat
        switch self {
        case .anotherType(height: let h):
            height = h
        case .oneType(height: let h):
            height = h
        }
        
        print(name + "_" + "\(height)" )
    }
}

var enumMo = EnumModel.oneType(height: 33)
enumMo.name = "enum"
enumMo.doSomething()


//协议-------------------------
protocol Model {
    var name:String {set get}
    func doSomething() -> ()
}

extension StructModel:Model{
}
extension ClassModel:Model{}

protocol OtherModel{
    func doOtherThing() -> ()
}

extension OtherModel{
    func doOtherThing() -> (){
        print("other model default doOtherThing")
    }
}

extension Int:OtherModel{
    func doOtherThing() -> (){
        print("int \(self) other model default doOtherThing")
    }
}

1.doOtherThing()


var models:[Model] = [classM,structM,enumMo]
var intArr:[Int] = [1,2,3]
var str:String = ""

models.forEach { (model) in
    model.doSomething()
    print("model's name is \(model.name),it will do something")
}


extension Model {
    func doSomething() -> () {
        print("\(name) do something")
    }
}

struct DoNothingStruct:Model {
    var name: String
}

let doNoSt = DoNothingStruct.init(name: "Do nothing Sturct")
doNoSt.doSomething()



//嵌套类型

struct Person {
    
    struct Identify {
        var id:Int64
        var createTime:String
    }
    
    var name:String
    var age:Int
    var id:Identify
}

extension Person:Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.id.id == rhs.id.id
    }
}

let soPerson = Person.init(name: "ZHang三", age: 20, id: Person.Identify.init(id: 9210190, createTime: "2020-09-22"))
let id2 = Person.Identify.init(id: 009990, createTime: "2020")

struct Identify {
    var id:Int64
    var createTime:String
}

let trID = Identify.init(id: 009990, createTime: "2020")




//模式匹配

//可选模式(特殊的枚举模式)-------------------------
let optIntV:Int? = 30
let optIntV2:Optional = Optional.some(20)
let optIntV3:Int? = nil
let optIntV4:Int? = Optional.none
let optIntV5:Int? = Optional.some(10)

let model:ClassModel?

//下面三者等价
if case Optional.some(let trV) = optIntV {
    print(trV)
}

if case let trV? = optIntV {
    print(trV)
}


if let trV = optIntV {
    print(trV)
}

//下面四者等价
if case Optional.some(let trV) = optIntV2 {
    print(trV)
}

if case let Optional.some( trV) = optIntV2 {
    print(trV)
}

if case let trV? = optIntV2 {
    print(trV)
}

if let trV = optIntV2 {
    print(trV)
}

//为nil时
if case Optional.some(let trV) = optIntV3 {
    print(trV)
}else{
    print("it's option.none,value == \(optIntV3)")
}

let intArray = [1,nil,3,nil,5]
for case let value? in intArray {
    print("value is \(value)")
}

for i in 0...5 {
    print("\(i)")
}


//枚举模式

enum SomeType {
    case first
    case second
    case third(value:Int?)
}

func descrip(_ someTypeValue:SomeType?) {
    switch someTypeValue {
    case .first:
        print("first")
    case .second:
        print("second")
    case .none:
        print("is nil")
    case .third(value: let some?):
        print("third vlue is \(some)")
//    case .third(value: let some):
//        print("third vlue is \(some)")
    case .some(let type):
        print("some type \(type)")
    }
}

let value:SomeType? = .third(value: 3)
let value2:SomeType? = .third(value: nil)
let value3:SomeType? = .second
let value4:SomeType? = .first
let value5:SomeType? = nil

[value,value2,value3,value4,value5].forEach({ descrip($0) })



//通配符模式
for _ in 0...3 {
    print("some")
}

//标识符模式
let strvalue = "3"
var strvalue2 = "3"


//值绑定模式
//let tuple = (first:1,second:2,third:"st",four:[1,2])

let tuple = (1,2)
let (x,y) = tuple 

switch tuple {
case let (x,y):
    print("in switch, x is \(x) ,y is \(y)")
}

//元祖模式
for (x,y) in [(1,2),(2,3),(3,4)] {
    print("if for in loop x is \(x) ,y is \(y)")
}


//表达式模式
var exIntValue = 100
var range = 1...4

if case range = exIntValue {
    print("if case \(exIntValue) is in range \(range)")
}

if range ~= exIntValue {
    print("compare with ~= \(exIntValue) is in range \(range)")
}


switch exIntValue {
case range:
    print("switch case \(exIntValue) is in range \(range) ")
default:
    print("switch case \(exIntValue) is not in range \(range) ")
}



protocol SomePr {
    func doSomething() -> ()
}





