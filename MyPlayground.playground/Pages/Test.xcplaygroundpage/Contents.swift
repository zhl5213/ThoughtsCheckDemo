//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import UIKit
import Darwin

let floatArray:[Float] = [120,121,122,123,124,125]

for value in floatArray {
    var targetValue:Float = value
    if Int(targetValue) % 5 != 0 {
        let intTargetValue = Int(targetValue)
        var divisionValue = intTargetValue / 5
        if abs((divisionValue + 1) * 5 - intTargetValue) < abs(divisionValue * 5 - intTargetValue) {
            divisionValue = divisionValue + 1
        }
        targetValue = Float(divisionValue * 5)
    }
    print(" origin value is \(value), final targetValue is \( String.init(format: "%dcm", Int(targetValue)))")
}



struct AlertMessage:Equatable {
    var level:Int
    var message:String
    var hasUserInteraction:Bool
    
}

var handledMessages:[AlertMessage] = [AlertMessage]()

func handlerAlertMessage(_ message:AlertMessage) -> () {
    if handledMessages.contains(where: { $0 == message }) == false {
        handledMessages.append(message)
    }else{
        let index = handledMessages.firstIndex(where: { $0 == message })!
        handledMessages.replaceSubrange(index...index, with: [message])
    }
    handledMessages = handledMessages.sorted(by: { $0.level < $1.level })
//    print("handler alert message is \(message),handledMessages is \(handledMessages)")
}

func removeAlertMessage(_ levels:[Int]) -> () {
    for level in levels {
        if let index = handledMessages.firstIndex(where: { $0.level == level }) {
            handledMessages.remove(at: index)
        }
    }
       print("remove  alert levels is \(levels),handledMessages is \(handledMessages)")
    
}

let tenMessage = AlertMessage.init(level: 10, message: "10", hasUserInteraction: false)
let tenMessage2 = AlertMessage.init(level: 6, message: "6", hasUserInteraction: false)
let handrndMessage1 = AlertMessage.init(level: 101, message: "100", hasUserInteraction: true)
let handrndMessage2 = AlertMessage.init(level: 110, message: "110", hasUserInteraction: true)
let handrndMessage3 = AlertMessage.init(level: 210, message: "210", hasUserInteraction: true)
let handrndMessage4 = AlertMessage.init(level: 209, message: "209", hasUserInteraction: true)

let allMEssages = [tenMessage,tenMessage2,handrndMessage1,handrndMessage2,handrndMessage3,handrndMessage4]
var copyMessages = allMEssages
//
for _  in (0..<allMEssages.count) {
    let randIndex = (0..<copyMessages.count).randomElement()
    handlerAlertMessage(copyMessages.remove(at: randIndex!))
}

var removedCopyMessages = allMEssages
for _  in (0..<allMEssages.count) {
    let randIndex = (0..<removedCopyMessages.count).randomElement()
    removeAlertMessage([removedCopyMessages.remove(at: randIndex!).level])
}



//CInt addTwo(CInt a,CInt b) {
//  return a + b
//}
var string:String = "1235guhiojvcfvbknlmn67890-98"
for char in string {
    if char <= "9" && char >= "0" {
        print("in \(string) find  number char \(char) ")
    }
}

var str = "hello,world"
let firstStr = "\(str.removeFirst())"

print("new str is \(str),firstStr is \(firstStr)")

let binInt:Int = 0b11000
let bstring = String.init(format: "%#X", binInt)
print("bin int is \(bstring)")


let oxhInt:Int = 0o123576653
let oxtring = String.init(format: "%d", oxhInt)
print("bin int is \(oxtring)")


let hexhInt:Int = 0xafad1223
let hextring = String.init(format: "%d", hexhInt)
print("bin int is \(hextring)")



class TestObject:NSObject {
    
    override class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
        if sel == Selector.init("eat") {
            
        }
        return super.resolveInstanceMethod(sel)
    }
    
    @objc func doSomething() -> () {
        print("do some thing")
    }
    
    @objc func findSomething(in container:String) -> String {
        return "nothing"
    }
    
}





let someObj = "<string name=total_storage_capacity>总容量</string>"


var startCha:Character = Character.init(Unicode.Scalar.init(97))
print("startCha.unicodeScalars is \(startCha.unicodeScalars.first?.value),startCha.asciiValue is \(startCha.asciiValue)")

func getRandomCharactor() -> Character {
    var startCha:Character = "a"
    var allCharaters = [Character]()
    for i in 0..<26 {
        let newAsca = Character.init(Unicode.Scalar.init(startCha.unicodeScalars.first!.value + UInt32(i))!)
//        print("newAsca is \(newAsca)")
        allCharaters.append(newAsca)
    }
    
    startCha = "A"
    for i in 0..<26 {
        let newAsca = Character.init(Unicode.Scalar.init(startCha.unicodeScalars.first!.value + UInt32(i))!)
//        print("newAsca is \(newAsca)")
        allCharaters.append(newAsca)
    }

    return allCharaters[Int(arc4random()) % 52]
}

let sC = getRandomCharactor()

//for _ in 0..<100 {
//    print("getRandomCharactor \(getRandomCharactor())")
//}


func getRandomDecimalInt() -> Int {
    return Int(arc4random() % 10)
}

for _ in 0..<100 {
    print("getRandomDecimalInt \(getRandomDecimalInt())")
}



//class TreeNode{
//
//    var value:Int = 0
//    var leftNode:TreeNode?
//    var rightNode:TreeNode?
//
//    func description() -> String {
//        var totalNodes = [TreeNode]()
//        var currentLevelNodes = [self]
//        while currentLevelNodes.count > 0 {
//            totalNodes.append(contentsOf: currentLevelNodes)
//            var newLevelNodes = [TreeNode]()
//            for node in currentLevelNodes {
//                if let trLeftNode = node.leftNode {
//                    newLevelNodes.append(trLeftNode)
//                }
//                if let trRightNode = node.rightNode {
//                    newLevelNodes.append(trRightNode)
//                }
//            }
//            currentLevelNodes = newLevelNodes
//        }
//
//        return totalNodes.reduce("", { $0 + "\($1.value)" })
//    }
//}

//let fateher = TreeNode.init()
//fateher.value = 8
//let seLeftNode = TreeNode.init()
//seLeftNode.value = 6
//let secRightNode = TreeNode.init()
//secRightNode.value = 10
//fateher.leftNode = seLeftNode
//fateher.rightNode = secRightNode
//
//
//let values = [5,7,9,11]
//var thrNodes = [TreeNode]()
//
//for value in values {
//    let node = TreeNode.init()
//    node.value = value
//    thrNodes.append(node)
//}
//
//seLeftNode.leftNode = thrNodes[0]
//seLeftNode.rightNode = thrNodes[1]
//secRightNode.leftNode = thrNodes[2]
//secRightNode.rightNode = thrNodes[3]
//
//fateher.description()


//简单工厂
extension UILabel {
    
    enum ThemeType:String {
        case title
        case subTitle
        case content
    }
    
    static func makeLabelWith(type:ThemeType)->UILabel {
        let label = UILabel.init()
        switch type {
        case .title:
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = UIColor.black
            label.textAlignment = .center
        case .subTitle:
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.gray
            label.textAlignment = .center
        case .content:
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.blue
            label.textAlignment = .left
        }
        return label
    }
}

let type = UILabel.ThemeType.content
var label = UILabel.makeLabelWith(type:type)
label.text = "\(type.rawValue)"


//工厂方法1
protocol LabelMaker{
   static func makeLabel() -> UILabel
}

struct TitleLabelMaker:LabelMaker {
    
    static func makeLabel() -> UILabel {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }
}

struct SubTitleLabelMaker:LabelMaker {
    
    static func makeLabel() -> UILabel {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }
    
}

//工厂方法2

class LabelMakerCls {
    
    class func makeLabel() -> UILabel {
        return UILabel.init()
    }
}


class TitleLabelMarkCls:LabelMakerCls {
    
    override class func makeLabel() -> UILabel {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }
}


class SubTitleLabelMarkCls:LabelMakerCls {
    
    override class func makeLabel() -> UILabel {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }
}


label = SubTitleLabelMaker.makeLabel()
label.text = "\(SubTitleLabelMaker.Type.self)"
label.frame = CGRect.init(x: 20, y: 50, width: 200, height: 30)
PlaygroundPage.current.liveView = label

//使用泛型的工厂方法1
protocol CustomView{
    associatedtype firstV:UIView
    associatedtype secondV:UIView
    static func createView(with firstView:firstV,secondView:secondV) -> UIView
}


extension CustomView {
    
    static func createView(with firstView:firstV,secondView:secondV) -> UIView {
        let container = UIView.init()
        container.addSubview(firstView)
        container.addSubview(secondView)
        return container
    }
}


struct MainViewMaker<F:UILabel,S:UIButton>:CustomView {
    typealias firstV = F
    typealias secondV = S
}


struct SubViewMaker<F:UILabel,S:UISwitch>:CustomView {
    typealias firstV = F
    typealias secondV = S
}


//使用泛型的工厂方法1
struct CustomTitleFactory {
    
    static func createProductView(with type:UILabel.Type) -> UILabel {
        return type.init()
    }
}

class CustomTitleLabel:UILabel {
    
    init() {
        super.init(frame: CGRect.zero)
        font = UIFont.systemFont(ofSize: 17)
        textColor = UIColor.black
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

CustomTitleFactory.createProductView(with: CustomTitleLabel.self)


//func createNodes(for level:Int)->[TreeNode]{
//    var nodes = [TreeNode]()
//
//    for _ in 0..<pow(2, level) {
//        let node = TreeNode.init()
//        node.value = Int(arc4random() % 100)
//        nodes.append(node)
//    }
//    return nodes
//}
//
//let thirdNodes = createNodes(for: 2)
//let secodeNodes = createNodes(for:1)
//let firstNodes  = createNodes(for: 0)

//let fatherNode = firstNodes[0]
//let totalNodes = firstNodes + secodeNodes + thirdNodes
//fatherNode.

//func createATreeWith(_ nodes:[TreeNode]) -> TreeNode? {
//    guard nodes.count > 0 else {
//        return nil
//    }
//    let fatherNode = nodes.first!
//    var level:Int = 0
//    var leftCount = nodes.count - pow(2, level)
//
//    while leftCount >= pow(2, level +1) {
//        level += 1
//
//    }
//
//    return fatherNode
//}


DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
    print("first global aysnc in thread \(Thread.current)")
    DispatchQueue.main.sync {
        print("second main thread sync in thread \(Thread.current)")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            print("third global thread async in thread \(Thread.current)")
            DispatchQueue.main.sync {
                print("four main thread sync in thread \(Thread.current)")
            }
        }
    }
}
  


var anGlobalResuult:String = otherGlobalResult
var otherGlobalResult:String = "an old tree"

struct ScopeStruct {
    
    lazy var someValue:(Int,String) = {
        return (1,self.anotherValue)
    }()
    
    mutating func doSomeThing() -> () {
        print("doSomeThing ,someValue is \(someValue),anotherValue is \(anotherValue)")
    }
    
    mutating func another() -> () {
        print("another func someValue is \(someValue),,anotherValue is \(anotherValue)")
    }
    
    
    func funcScope() -> () {

//        var anResuult:String = someResult
//        var someResult:String = "an old tree"
    }
    
     var anotherValue:String = "an apple"    
    
}




//func randowStringWith(count:Int) -> String {
//    var string = ""
//    for _ in 0..<count {
//        let randomStr = String.init(Character.init(Unicode.Scalar.init(0x4E00 + arc4random() % 4000)!))
//        string += randomStr
//    }
//    return string
//}
//
//let randomStr21 = randowStringWith(count: 21)
//print("randomStr21 is \(randomStr21)")

let value:Int = 3
print(String.init(format: "%03d", value))

var arr = [1,2,3,5,6,7]
for intV in arr.enumerated() {
    if intV.element % 2 == 0 {
        arr.replaceSubrange(intV.offset...intV.offset, with: [0])
    }
}
print(arr)



class SomeClass:NSObject {
    
    var someBlock:(()->())?
    var name:String = ""
    
    deinit {
        print("SomeClass deinit")
    }
}



class SomeVC:UIViewController {
    
    
    lazy var button: UIButton = {
        let bt = UIButton.init(type: .custom)
        bt.setTitle("按钮-normal", for: .normal)
        bt.setTitle("按钮-被选中", for: .selected)
        bt.setTitleColor(UIColor.blue, for: .normal)
        bt.setTitleColor(UIColor.red, for: .selected)
        bt.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: .touchUpInside)
        return bt
    }()
    
    
    lazy var object: SomeClass? = {
        let newCls = SomeClass.init()
        newCls.someBlock = { [unowned newCls,weak self]in
            newCls.name = "SomeClass"
            print("self is\(self)")
        }
        return newCls
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        view.addSubview(button)
        button.frame = CGRect.init(x: 150, y: 230, width: 200, height: 20)
    }
  
    
    @objc func buttonIsTapped(sender:UIButton) -> () {
        
        if let _ = object {
            self.object = nil
            print("object set nil")
        }
        
    }
    
}


PlaygroundPage.current.liveView = SomeVC.init()


struct TestStruct {
    
    var name:String?
    var count:Int?
  
    func genericFunc<T:StringProtocol>(with value:T) -> () {
        print(" str \(value)")
    }
}


let tstruct = TestStruct.init(name: "12", count: 3)
tstruct.genericFunc(with: "123")


