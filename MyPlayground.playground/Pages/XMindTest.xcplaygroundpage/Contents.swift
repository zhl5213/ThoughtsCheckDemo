//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"


func getValidRatioOf(firstFactor:Int,secondFacotr:Int,thirdFactor:Int,sum:Int) {

    var finalFactor:(fRatio:Int,sRatio:Int,thirdRatio:Int)?
    outerLoop: for fRatio in 1..<(sum/firstFactor + 1) {
        var sRatio = 1
        while firstFactor * fRatio + secondFacotr * sRatio <= sum - thirdFactor {
            if (sum - firstFactor * fRatio - secondFacotr * sRatio) % thirdFactor  == 0 {
                finalFactor = (fRatio * firstFactor,sRatio * secondFacotr,(sum - firstFactor * fRatio - secondFacotr * sRatio))
                break outerLoop
            }else {
                sRatio += 1
            }
        }
    }
    
    if let trfinalFactor = finalFactor {
        print("trfinalFactor is \(trfinalFactor)")
        for _ in 0..<trfinalFactor.fRatio {
            print("foo")
        }
        for _ in 0..<trfinalFactor.sRatio {
            print("bar")
        }
        for _ in 0..<trfinalFactor.thirdRatio {
            print("foobar")
        }
    }
    
}

getValidRatioOf(firstFactor:3,secondFacotr:5,thirdFactor:15,sum:100)




