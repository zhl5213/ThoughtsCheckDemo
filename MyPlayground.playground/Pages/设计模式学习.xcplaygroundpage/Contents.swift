//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

/*工厂方法模式*/

protocol Operation {
    func operate(firstNumber:Int,secondNumber:Int)->Int
}

struct AddIntOperation:Operation {
    func operate(firstNumber: Int, secondNumber: Int) -> Int {
        return firstNumber + secondNumber
    }
}

struct SubIntOperation:Operation {
    func operate(firstNumber: Int, secondNumber: Int) -> Int {
        return firstNumber - secondNumber
    }
}


protocol OperationFactory {
     func createOperation() -> Operation
}

struct AddIntFactory:OperationFactory {
    
     func createOperation() -> Operation {
        return AddIntOperation()
    }
}

struct SubIntFactory:OperationFactory {
     func createOperation() -> Operation {
        return SubIntOperation()
    }
}


class Caculator {
        
    func caculate(with userInput:String) -> OperationFactory? {
        switch userInput {
        case "+":
            return AddIntFactory()
        case "-":
            return SubIntFactory()
        default:
            return nil
        }
    }
    
    func caculateAsUserInput(firstNumber:Int,operatorStr:String,secondNumber:Int) -> Int? {
        if let factory = caculate(with: operatorStr) {
            return factory.createOperation().operate(firstNumber: firstNumber, secondNumber: secondNumber)
        }else {
            return nil
        }
    }
    
}







/*工厂方法模式*/


/*抽象工厂*/

protocol Product {
    var name:String  { set get }
    func excute() -> ()
}

protocol ETool {
    var id:Int {set get}
    func dodo() -> ()
}

protocol Zone {
    var name:String {set get }
}

protocol SerialFactory {
    func createProduct(with name:String) -> Product
    func createEtool(with id:Int) -> ETool
}

var name: String
    
struct Zone1ConcoreteProduct:Product {
    var name: String
    
    func excute() {
        print("in zone 1, product for name \(name) excute")
    }
}

struct Zone1Tool:ETool {
    var id: Int
    
    func dodo() {
        print("in zone 1, id \(id) dod o ")
    }
}


struct Zone204ConcoreteProduct:Product {
    var name: String
    
    func excute() {
        print("204,product for name \(name) excute")
    }
}

struct Zone204Tool:ETool {
    var id: Int
    
    func dodo() {
        print("204, id \(id) tool dod o ")
    }
}




struct FirstFactory:SerialFactory {
    func createEtool(with id: Int) -> ETool {
        return Zone1Tool.init(id: id)
    }
    
    func createProduct(with name:String) -> Product {
        return Zone1ConcoreteProduct.init(name: name)
    }
    
}

struct _204Factory:SerialFactory {
    func createEtool(with id: Int) -> ETool {
        return Zone204Tool.init(id: id)
    }
    
    func createProduct(with name:String) -> Product {
        return Zone204ConcoreteProduct.init(name: name)
    }
}

struct TopFactory:SerialFactory {
    var serialName:String
    func createProduct(with name: String) -> Product {
        if serialName == "Zone1" {
            return Zone1ConcoreteProduct.init(name: name)
        }else {
            return Zone204ConcoreteProduct.init(name: name)
        }
    }
    
    func createEtool(with id: Int) -> ETool {
        if serialName == "Zone1" {
            return Zone1Tool.init(id: id)
        }else {
            return Zone204Tool.init(id: id)
        }
    }
    
}







