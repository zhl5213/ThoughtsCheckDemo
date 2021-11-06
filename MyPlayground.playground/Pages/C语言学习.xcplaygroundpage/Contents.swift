//: [Previous](@previous)

import Foundation

/* ------------------字符串语法专题-------------------------------*/
var char:Character = "A"

print("%s 测试 %20s spacing")

let array = "striig"

for char in array.enumerated() {
    if char.element == "1",let intV = Int.init(String(char.element)) {
       
    }
}


/* ------------------字符串语法专题-------------------------------*/



/* ------------------浮点数语法专题-------------------------------*/

var decimalFloat:Float = 1.1
var decimalFloat2:Float = 1.3
if decimalFloat + decimalFloat2  == 2.4 {
    print("is equl")
} else {
    print("is not equal")
}
var floatStr = String.init(format: "first float value is %.20f,second float is %.20f", arguments: [decimalFloat,decimalFloat2])
print(floatStr)
print("first decimal double is \(decimalFloat),second is \(decimalFloat2), summer is \(decimalFloat + decimalFloat2)")


let maxFloat:Float = Float.greatestFiniteMagnitude
let minFloat:Float = -Float.greatestFiniteMagnitude
let overFlowFloat = maxFloat * 2
let blowFlowFloat = minFloat * 2
var floatPrecisionLost = maxFloat + 1

//浮点数的精度范围为7位，计算时，超过7位的值会被忽略掉
var floatPrecisionLost3:Float = 2.13e7 + 1
//超过7位的存储的时候会被忽略掉
var floatPrecisionLost2:Float = 9.21734581
var literalDouble = 3.1415
var ommitFloat = 0.5

print("max float : \(maxFloat); min float : \(minFloat); overFlow float : \(overFlowFloat), blowFlow float : \(blowFlowFloat),floatPrecisionLost is \(floatPrecisionLost - maxFloat),floatPrecisionLost2 is \(floatPrecisionLost2),floatPrecisionLost3 is \(floatPrecisionLost3)")

/* ------------------浮点数语法专题-------------------------------*/


