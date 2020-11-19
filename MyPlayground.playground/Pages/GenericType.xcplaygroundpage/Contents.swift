//: [Previous](@previous)

import Foundation
import UIKit

//MARK - 泛型函数

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

//
//var double1 = 1.00
//var double2 = 2.00
//
//swapCustom(first: &double1, second: &double2)


func swapCustom<Semn>(first:inout Semn,second:inout Semn)->() {
    let temp = first
    first = second
    second = temp
    print("first \(first),second \(second)\(first)")
}




//泛型类型
struct GenericStruct<T:Sequence> /*where T.Element == Int*/ {
    
    var sequence:T?
    
    func doSomething() -> () {
        print("t's type =\(T.self)")
        if let trSequence = sequence {
            for element in trSequence {
                print("element is \(element)")
            }
        }
    }
    
    mutating func set(NewSequence:T) -> () {
        sequence = NewSequence
    }
}

let arrayStruct = GenericStruct<[Int]>.init(sequence: [1,3,3,3,3,5,200])
arrayStruct.doSomething()

var setStruct = GenericStruct<Set>.init(sequence: [1,3,3,3,5,200])
setStruct.doSomething()
setStruct.set(NewSequence: [2,4,4,3,3,5])
setStruct.doSomething()

let dicStruct = GenericStruct<[String:Float]>.init(sequence: ["1": 1,"2":3,"3":5])
dicStruct.doSomething()


extension GenericStruct  /*where T.Element == Int*/ {
    
    func otherThing() -> () {
        print("t's Type \(T.self)")
    }
}





//关联类型的协议；
protocol Animal {
    associatedtype Food
    var mainFood:Food { set get }
    func eate(_ type:Food) -> ()
}

protocol Plant {
    var color:UIColor { set get }
}

struct Grass:Plant {
    var weight:Double
    var color:UIColor
    static func normal()->Grass {
        return self.init(weight: 10.0, color: UIColor.green)
    }
}

struct Flower:Plant {
    var length:Double
    var color:UIColor
    static func normal()->Flower {
        return self.init(length: 10.0, color: UIColor.red)
    }
}


struct Beast:Animal {
    var mainFood: Grass
    typealias Food = Grass
    static func normal()->Beast {
        return self.init(mainFood: Grass.normal())
    }
    func eate(_ type: Grass) {
        
    }
}

struct Bird:Animal {
    var mainFood: Flower
    typealias Food = Flower
    static func normal()->Bird {
        return self.init(mainFood: Flower.normal())
    }
    func eate(_ type: Flower) {
        
    }
}

//正确示范
struct Pepole<T:Animal>:Animal {
    typealias Food = T
    var mainFood: T
    func eate(_ type: T) {
        
    }
}

//错误示范：
//struct OtherPepole:Animal {
//    typealias Food = Animal
//    var mainFood: Animal
//    func eate(_ type: Animal) {
//
//    }
//}


let eatBeastPepole = Pepole.init(mainFood: Beast.init(mainFood: Grass.init(weight: 2.0, color: UIColor.green)))
let eatBirdPepole = Pepole.init(mainFood: Bird.init(mainFood: Flower.init(length: 10.0, color: UIColor.red)))


let plants = [Plant]()
func eateSome(_ food:Plant)->(){}


//错误示范：
//let animals:[Animal] = [Animal]()
//Protocol 'Animal' can only be used as a generic constraint because it has Self or associated type requirements
//func eateSome(_ food:Animal)->(){
//
//}
func eateSome<T:Animal>(_ food:T)->(){
    print(food)
}

//func eateSomeOther(_ food:Animal)->(){
//    print(food)
//}

protocol NormalPr {
    func some() -> () 
}

func doSome(firstSeq:NormalPr,secondSE:NormalPr) {
    
}




//正确示范
eateSome(Beast.init(mainFood: Grass.init(weight: 2.0, color: UIColor.green)))


extension Array:Animal where Element:Plant {
    typealias Food = Element
    var mainFood: Element {
        get {
            return last ?? 1 as! Element
        }
        set {
            append(newValue)
        }
    }
    
    func eate(_ type: Element) {
        
    }
}




//where描述语句,细化泛型、关联类型；

func towAnimaiFight<S1:Animal,S2:Animal>(_ first:S1,_ second:S2) ->() where S1.Food == Grass,S2.Food == Flower {
    print(first)
    print(second)
}


struct FlowerPepole<T:Animal> where T.Food == Flower {
    var food:T
}


//错误示范
//let sPeople = FlowerPepole.init(food: Beast.normal())
//正确示范
let flowerPepole = FlowerPepole.init(food: Bird.normal())


extension Animal where Food == Grass {
    
    func fightFor(_ food:Food) ->() {
        
    }
}

//错误示范
//Beast.normal().fightFor(Flower.normal())
//Bird.normal().fightFor(Flower.normal())
//正确示范
Beast.normal().fightFor(Grass.normal())




