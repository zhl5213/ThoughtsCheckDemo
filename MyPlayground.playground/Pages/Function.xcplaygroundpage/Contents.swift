//: [Previous](@previous)

import Foundation
import UIKit


@discardableResult
func aCompletFunc(willSet innerPara1:Int = 0,and innerPara2:String?,canModifyValue:inout Int) -> Int {
    print(innerPara2 ?? "")
    canModifyValue += innerPara1
    return innerPara1 * canModifyValue
}

var modiValue:Int = 100
aCompletFunc(willSet: 10, and: "innerParameter", canModifyValue: &modiValue)


//函数、参数名可以完成相同
func swapCustom(first:inout Int,second:inout Int)->() {
    let temp = first
    first = second
    second = temp
    print("first \(first),second \(second)")
}

var int1 = 1
var int2 = 2


func swapCustom(first:inout String,second:inout String)->() {
    let temp = first
    first = second
    second = temp
    print("first \(first),second \(second)")
}

var str1 = "1Str"
var str2 = "2Str"
swapCustom(first: &str1, second: &str2)
swapCustom(first: &int1, second: &int2)

var func1:((inout Int,inout Int)->())?
func1 = swapCustom(first:second:)

var func2:((inout String,inout String)->())?
func2 = swapCustom(first:second:)


func swapCustom<T>(first:inout T,second:inout T)->() {
    let temp = first
    first = second
    second = temp
    print("first \(first),second \(second)")
}


//函数的使用

func funcAdd(value1:Int,value2:Int) ->Int {
    return value1 + value2
}

func funcMulityply(value1:Int,value2:Int) ->Int {
    return value1 * value2
}


struct FuncStruct {
    
    var aFunc:(Int,Int)->Int
    
    mutating func replaceFuncWith(newFunc:@escaping (Int,Int)->Int) -> () {
        aFunc = newFunc
    }
    
    func excuteFunc(with value1:Int,value2:Int) -> Int {
        return aFunc(value1,value2)
    }
    
    func currentFunc() -> (Int,Int)->Int {
        return aFunc
    }
}


var funcStruct = FuncStruct.init(aFunc: funcAdd(value1:value2:))
//print("current funct =\(String(describing: funcStruct.currentFunc()))")
print("funcStruct excute result is \(funcStruct.excuteFunc(with: 1, value2: 2))")


funcStruct.replaceFuncWith(newFunc: funcMulityply(value1:value2:))
print("funcStruct excute result is \(funcStruct.excuteFunc(with: 1, value2: 2))")


let currentFunc = funcStruct.currentFunc()
print("funcStruct currentFunc excute result is \(currentFunc(1,2))")



//系统自带的高阶函数
let arr1 = [12,2,3,5,10,19999]

//单表达式闭包的隐式返回
let ouArr =  arr1.filter({ $0 % 2 == 0 })

arr1.filter({ (intValue) -> Bool in return intValue % 2 == 0 })
print("ouArr is \(ouArr)")

//根据上下文推断类型
let addedResult = arr1.reduce(0, { $0 + $1 })
print("addedResult is \(addedResult)")

//参数名称缩写
let arrMulitPly3 = arr1.map({ $0 * 3 })
print("arrMulitPly3 is \(arrMulitPly3)")

var arrCompare = arr1.sorted(by: > )
print("arrCompare is \(arrCompare)")

func compare(firstVa:Int,secondVa:Int) -> Bool {
    return firstVa < secondVa
}

var arrCompare2 = arr1.sorted(by: compare(firstVa:secondVa:) )
print("arrCompare2 is \(arrCompare2)")



//闭包
//全局函数是一个有名字但不会捕获任何值的闭包
//嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
//闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包

//block作为变量;值捕获（闭包是引用类型）
var capturedValue = 100

let someBlock:(_ name:String,_ age:Int)->(String,Int) = { [unowned someObject](name,age)->(String,Int) in
    print("simple name is \(name), age is \(age),capturedValue =\(capturedValue)\(someValue)")
    capturedValue += 10
    return (name,age)
}

let someObject:NSObject = NSObject.init()

func someFunc(_ name:String,_ age:Int)->(String,Int) {
    print("simple name is \(name), age is \(age),capturedValue =\(capturedValue)\(someValue)")
    capturedValue += 10
    return (name,age)
}


//var bResult:(String,Int)? = bResult2
//let bResult2 = someBlock("张三",200)
//
//print(bResult)
//print(bResult2)
var someValue:String = "下文"


func createAPersonWith(block:(_ name:String,_ age:Int)->(String,Int))-> (String,Int){
    if arc4random() % 2 == 1 {
       return block("好人",10000)
    }else {
        return block("坏人",1)
    }
}

let somePerson = createAPersonWith(block: someBlock)
//尾随自定义闭包
let introducePerson2 = createAPersonWith { (name, age) -> (String, Int) in
    print("this is \(name),his age is \(age)")
    return ("this is " + name, age)
}


//自动闭包，不接受任何参数；延迟求值;
var name:String = "王五"
var age = 111
let someResut = { [unowned object]() -> (String,Int) in
    print("name is \(name), age is \(age),object is \(object),capturedValue =\(capturedValue)")
    capturedValue += 10
    return (name,age)
}()

print(someResut)
print(someResut)

var object = NSObject.init()

//自动闭包的常规使用
struct ViewCreater {
    
    lazy var someView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.red
        return view
    }()
    lazy var intValue: Int = 3
    var someValue:Int
}

let creater = ViewCreater.init(someView: nil, intValue: nil, someValue: 30)


//逃逸闭包

func doSomethingAsyncWith(block:@escaping ()->()) {
    DispatchQueue.global().async {
        block()
    }
}

doSomethingAsyncWith {
    print("aync things")
}
print("sync things")


//嵌套函数

func doSomething(needAsync:Bool){
    
    func excute(){
        print("hello,world,\(needAsync ? "is Async" : "is sync")")
    }
    
    if needAsync {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 5) {
            excute()
        }
    }else {
        excute()
    }
}

doSomething(needAsync: true)
doSomething(needAsync: false)
