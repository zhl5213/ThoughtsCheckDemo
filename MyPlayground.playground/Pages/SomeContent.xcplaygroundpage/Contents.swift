//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

let frQueue = DispatchQueue.init(label: "cn.com.minieye.test1")
let seQueue = DispatchQueue.init(label: "cn.com.minieye.test2")
let thQueue = DispatchQueue.init(label: "cn.com.minieye.test3")
let queues = [frQueue,seQueue,thQueue]
let group = DispatchGroup.init()

class TargetClass:NSObject {
    
    let selector = #selector(TargetClass.printLog(_:))
    let aliveSelector = #selector(TargetClass.keepThreadLive)
    lazy var frthread = Thread.init(target: self, selector: aliveSelector, object: nil)
    lazy var sethread = Thread.init(target: self, selector: aliveSelector, object: nil)
    lazy var ththread = Thread.init(target: self, selector: aliveSelector, object: nil)
    lazy var threads = [frthread,sethread,ththread]
    var countNumber:Int = 0

    override init() {
        super.init()
        threads.forEach({ $0.start() })
    }
    
    @objc func keepThreadLive() {
        let currentRunloop = RunLoop.current
        currentRunloop.add(Port.init(), forMode: .common)
        currentRunloop.run()
    }
    
    func testFunc() -> () {
        for i in 0..<100 {
            let index = i % 3
            perform(selector, on: threads[index], with: NSNumber.init(value: i), waitUntilDone: true)
        }
    }
    
    @objc func printLog(_ index:NSNumber) {
        print("i is \(index.intValue) in thread \(Thread.current)")
    }
    
    
}

let target = TargetClass.init()
target.testFunc()




