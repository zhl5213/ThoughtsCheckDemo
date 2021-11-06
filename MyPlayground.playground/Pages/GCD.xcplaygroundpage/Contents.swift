//: [Previous](@previous)

import Foundation

class TestObject:NSObject {
    var name:String?
}

let times = 3
let semaphore = DispatchSemaphore.init(value: -times+1)

print("first thing")
DispatchQueue.global().async {
    semaphore.wait()
    print("need do something after other \(times) things")
}

DispatchQueue.global().async {
    print("do first thing")
//    Thread.sleep(forTimeInterval: 1)
    semaphore.signal()
}

DispatchQueue.global().async {
    print("do second thing")
//    Thread.sleep(forTimeInterval: 0.5)
    semaphore.signal()
}

DispatchQueue.global().async {
    print("do third thing")
//    Thread.sleep(forTimeInterval: 1)
    semaphore.signal()
}

print("haha main thread thing")



class SomeClass:NSObject {
    let semaphore = DispatchSemaphore.init(value: 1)
    private let councurrentQueue = DispatchQueue.init(label: "cn.com.minieye.cc.test.someClass.concurrent", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    
    
    //当没有进行线程安全设计的时候，有可能会出现下面的情况，在读某个值之后，正要使用它，其他的线程修改了它。
//    read property is odd number 奇数，is value is 18
//    read property is even number 偶数，is value is 18
//    read property is even number 偶数，is value is 18
    var changedValueTimes:Int = 0
    private var _propertyRW:TestObject?
    var propertyRW:TestObject?
    {
//        set{
//            semaphore.wait()
//            _propertyRW = newValue
//            print("set new property \(newValue["index"])")
//            semaphore.signal()
//        }
//        get{
//            semaphore.wait();defer{ semaphore.signal() }
//
//            return _propertyRW
//        }
        set{
            semaphore.wait(timeout: DispatchTime.now())
            councurrentQueue.async(flags: .barrier, execute: {
                self._propertyRW = newValue
                print("---set new property \(newValue?.name) in thread \(Thread.current)")
            })
        }
        get{
            var value:TestObject?
            councurrentQueue.sync(execute: {
                value = _propertyRW
                print("-get new property \(value?.name) in thread \(Thread.current)")
            })
            return value
        }
    }
}

let instance = SomeClass.init()

func readAndWriteProperty() -> () {
    let anotherQueue = DispatchQueue.init(label: "cn.com.minieye.cc.test.someClass.concurrent2", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    for i in 0..<1000 {
        anotherQueue.async {
            print("get new property \(String(describing: instance.propertyRW?.name)) in thread \(Thread.current)")
        }
        anotherQueue.async {
            let newOb = TestObject.init()
            newOb.name = "name \(i)"
            instance.propertyRW = newOb
        }
    }
}
readAndWriteProperty()

var str = "Hello, playground"

let firstBlock = {
    for i in 0..<20 {
        print("first thing at \(i) thread \(Thread.current),will sleep 0.1 second")
        Thread.sleep(forTimeInterval: 0.1)
    }
}

let secondBlock = {
    for i in 0..<10 {
        print("seond thing at \(i) thread \(Thread.current),will sleep 0.1 second")
        Thread.sleep(forTimeInterval: 0.1)
    }
}


let thirdBlock = {
    for i in 0..<5 {
        print("third thing at \(i) thread \(Thread.current),will sleep 0.1 second")
        Thread.sleep(forTimeInterval: 0.1)
    }
}

let fourthBlock = {
    for i in 0..<5 {
        print("fourth thing at \(i) thread \(Thread.current),will sleep 0.1 second")
        Thread.sleep(forTimeInterval: 0.1)
    }
}


let finalBlock = {
    print("final work excuted ")
}

let secondFinalBlock = {
    print("second final work excuted ")
}


let customSerialQueue = DispatchQueue.init(label: "cn.com.minieye.www.test.serailTest", qos: .default, attributes: [], autoreleaseFrequency: .workItem, target: nil)

let customConcurrentQueue = DispatchQueue.init(label: "cn.com.minieye.cc.test", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
let customConcurrentQueue2 = DispatchQueue.init(label: "cn.com.minieye.cc.test2", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)

let group = DispatchGroup.init()

DispatchQueue.concurrentPerform(iterations: 10) { (index) in
    print("current idnex is \(index),thread is \(Thread.current)")
}
finalBlock()
//1.普通的异步执行。firstBlock执行一句话，secondBlock执行一句话，立即执行finalBlock。
//customConcurrentQueue.async(execute: firstBlock)
//customConcurrentQueue.async(execute: secondBlock)
//finalBlock()

//customConcurrentQueue.asyncAfter(deadline: DispatchTime.now(), execute: secondBlock)
//customConcurrentQueue.sync(flags: .barrier, execute: finalBlock)

//2.1  使用dispatchGroup.notify()等待第一个和第二个执行完成之后再执行最终的代码
//customConcurrentQueue.async(execute: {
//    customConcurrentQueue.async(group: group, execute: firstBlock)
//    customConcurrentQueue.async(group: group, execute: secondBlock)
//    group.notify(customConcurrentQueue: customConcurrentQueue, execute: finalBlock)
//})



//2.2 使用dispatchGroup.wait()存在等待完成 == 2.1
//customConcurrentQueue.async(execute: {
//    customConcurrentQueue.async(group: group, execute: firstBlock)
//    customConcurrentQueue.async(group: group, execute: secondBlock)
//    group.wait()
//    finalBlock()
//})


//2.3 二者同时存在
//customConcurrentQueue.async(execute: {
//    customConcurrentQueue.async(group: group, execute: firstBlock)
//    customConcurrentQueue.async(group: group, execute: secondBlock)
//    group.wait(timeout: DispatchTime.now() + 0.2)
//    print("group wait ended will notify")
//    group.notify(customConcurrentQueue: customConcurrentQueue, execute: finalBlock)
//})


//2.4 enter|leave，这两个方法类似于信号量，插入等于等待，
//customConcurrentQueue.async(execute: {
//    customConcurrentQueue.async(execute: {
//        firstBlock()
//        group.leave()
//    })
//    group.enter()
//    customConcurrentQueue.async(execute: {
//        secondBlock()
//        group.leave()
//    })
//    group.enter()
//    group.wait(timeout: DispatchTime.now() + 0.2)
//    print("group wait ended will notify")
//    group.notify(customConcurrentQueue: customConcurrentQueue, execute: finalBlock)
//})


//2.5 两个不同的queue，添加到同一个group中;效果一样，都是先执行group中的代码，最后执行notify中的代码。下里面的代码中，first\second\third\fourth中的代码执行完了才会执行两个finalblock。
//customConcurrentQueue.async {
//    customSerialQueue.async(group: group, execute: firstBlock)
//    customSerialQueue.async(group: group, execute: secondBlock)
//    customConcurrentQueue.async(group: group, execute: thirdBlock)
//    customConcurrentQueue.async(group: group, execute: fourthBlock)
//    group.notify(queue: DispatchQueue.main, execute: secondFinalBlock)
//    group.notify(queue: customSerialQueue, execute: finalBlock)
//}




//3. barrier。注意，3.1。栅栏必须是自定义的queue才有用，如果是global无用；2.栅栏必须针对是并发队列，串行队列无用；
//customConcurrentQueue.async {
//    customConcurrentQueue.async(execute: firstBlock)
//    customConcurrentQueue.async(execute: secondBlock)
//    customConcurrentQueue.asyncAfter(deadline: DispatchTime.now(), qos: .default, flags: .barrier, execute: finalBlock)
////    customConcurrentQueue.sync(flags: .barrier, exexcute: finalBlock)
//    customConcurrentQueue.async {
//        print("aysnc things after barrier")
//    }
//}


//4.信号量。信号量控制的是当前队列执行的任务数量，它无法起到等待所有任务都完成之后再进行下一个任务的功能。下面的代码中，finalBlock会在firstBlock执行完成之后执行，而不是等firstBlock和secondBlock执行完成之后再一起执行。
//let sephonme = DispatchSemaphore.init(value: 2)
//
//customConcurrentQueue.async(execute: {
//    sephonme.wait()
//    firstBlock()
//    sephonme.signal()
//})
//customConcurrentQueue.async(execute: {
//    sephonme.wait()
//    secondBlock()
//    sephonme.signal()
//})
//sephonme.wait()
//customConcurrentQueue.sync(execute: finalBlock)

//print("some thing after customConcurrentQueue excute ")


//多个网络请求之后再执行某段代码最终的实现思路。disptchGroup + enter() + leave()。
//let httpQueue = OperationQueue.init()
//httpQueue.maxConcurrentOperationCount = 1
//httpQueue.isSuspended = true
//
//group.enter()
//httpQueue.addOperation {
//    print("first http request response ")
//    DispatchQueue.main.async {
//        firstBlock()
//        group.leave()
//    }
//}
//DispatchQueue.global().async {
//    Thread.sleep(forTimeInterval: 3)
//    httpQueue.isSuspended = false
//}
//
//
//let secondhttpQueue = OperationQueue.init()
//secondhttpQueue.maxConcurrentOperationCount = 1
//secondhttpQueue.isSuspended = true
//
//group.enter()
//secondhttpQueue.addOperation {
//    print("second http request response")
//    DispatchQueue.main.async {
//        secondBlock()
//        group.leave()
//    }
//}
//DispatchQueue.global().async {
//    Thread.sleep(forTimeInterval: 2)
//    secondhttpQueue.isSuspended = false
//}
//
//
//group.notify(queue: customConcurrentQueue, execute: finalBlock)



let operationQueue = OperationQueue.init()
operationQueue.addOperation(firstBlock)

