//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let array = [3,4,1,2]

let arraySlice = array[1...2]

func createRandomArray(_ numbers:Int)->[Int] {
    var array = [Int]()
    for _ in 0..<numbers {
        let value = Int(arc4random() % 10000)
        array.append(value)
    }
    return array
}
var randomArray15 = createRandomArray(10)
print(randomArray15)


//8.计数排序。


print(pow(2, 3))
print(abs(-3))




//7.归并排序。使用空间换取时间的方法，将堆不停的等分为两个子数组，最小数组为1个。然后将子数组从下向上合并，
/*
 （1）归并排序有两个递归方法，两个递归方法交叉进行。第一个递归方法是将数组划分为两个子数组，第二个递归方法是将两个子数组重新合并为一个新的数组。
 （2）划分递归的结束为数组元素为1个的时候；
 （3）两个子数组合并到一个新的数组的时候。注意后来的新元素都是向前插入，插入的位置不会大于自己原数组前一个元素的位置。
 */

func mergeSort(_ array:[Int])->[Int] {
    
    func merge(leftSubArray:[Int],rightSubArray:[Int])->[Int] {
        var result = [Int]()
        
        for index in 0...leftSubArray.count-1 {
            print("merge left subarray \(leftSubArray),and right subarray \(rightSubArray) at index \(index)")
            if result.count == 0 {
                result.append(leftSubArray[0])
            }else {
               let insertValue = leftSubArray[index]
                var insertIndex = result.endIndex
                while insertValue < result[insertIndex-1] {
                    insertIndex -= 1
                }
                result.insert(insertValue, at: insertIndex)
            }
            
            if index <= rightSubArray.endIndex-1 {
                let insertValue = rightSubArray[index]
                 var insertIndex = result.endIndex
                while insertIndex - 1 >= 0 && insertValue < result[insertIndex-1] {
                     insertIndex -= 1
                 }
                 result.insert(insertValue, at: insertIndex)
            }
        }
        print("merge finished result is \(result)")
        return result
    }
    
    if array.count == 1 {
        return array
    }
    let centerIndex = (array.count-1)/2
    let leftSubArray = Array(array[0...centerIndex])
    let rightSubArray = Array(array[centerIndex+1...array.count-1])
    
    print("merge sort for array \(array),leftsubArray is \(leftSubArray),rightSubArray is \(rightSubArray) ")
    return merge(leftSubArray: mergeSort(leftSubArray), rightSubArray: mergeSort(rightSubArray))
}

print(mergeSort(randomArray15))


//6.堆排序。将数组转化为一个最大堆，最大堆是一个完全体的二叉树。它的特点是父节点的值一定比两个子节点的值大，但是子节点之间的值无法确定。堆排序的方式是每次取出堆的顶点值（最大值），然后将最后一个节点置顶，然后重置堆，再取出再重置。
/*
 （1）堆排序的关键点是要创建一个堆，然后设置堆的调整方法（重新变为最大堆）。
 （2）堆的创建和调整方法可以说是一体的，创建可以看成是调整所有的节点。
 （3）排序的时候，创建一个空的容器。移除堆顶点，将该顶点置于容器末尾，该值即为最大值；
 （4）然后将堆最后的节点移除，调整为新到顶点，然后调整堆。
 （5）调整完成之后，再执行（3）；循环执行直到堆内元素数量清空。
 */

func resetHeap(_ heap:inout [Int],node:Int) {
    let heapNodes = heap.count
    let leftNode = 2 * node + 1
    let rightNode = 2 * node + 2
    var largestNode = node
    
    print("heap is \(heap), at node \(node) value is \(heap[node])")

    if leftNode < heapNodes,heap[largestNode] < heap[leftNode] {
        largestNode = leftNode
    }
    
    if rightNode < heapNodes,heap[largestNode] < heap[rightNode] {
        largestNode = rightNode
    }
    
    if largestNode != node {
        print("largest node \(largestNode) != node \(node),will exchange value and go")
        (heap[largestNode],heap[node]) = (heap[node],heap[largestNode])
        resetHeap(&heap, node: largestNode)
    }
}



func heapSort(_ array:[Int]) -> [Int] {
    
    let maxheapNodes = array.count / 2
    var heap = array
    for index in (0...maxheapNodes).reversed() {
        resetHeap(&heap, node: index)
    }
    
    var sortedArray = [Int]()
    
    while heap.count > 0 {
        sortedArray.insert(heap.removeFirst(), at: 0)
        if heap.count > 1 {
            heap.insert(heap.removeLast(), at: 0)
            resetHeap(&heap, node: 0)
        }
    }
    
    return sortedArray
}

print(heapSort(randomArray15))


//5.希尔排序。希尔排序是对插入排序的优化。它设置一个增量序列IncrementalSequence，使用增量序列中的每个增量将数组划分为若干个子数组，然后对子数组进行插入排序。
/*
 (1)增量序列一般为[N/2,N/4...1]，对于增量序列中的每个值incremental。将目标数组分为incremental个子数组。这些子数组不是连续的，他们的index是以增量的方式增加的，他们的index一般为[0,incremental,2*incremental...]，[1,1+incremental,1+2*incremental...].
 （2）对于每个子数组，进行差值排序。
 （3）实际代码执行过程中，不是按照一个个的序列来执行的；而是交叉进行的（因为按照序列来执行不连续）
 */

func xierSort(_ array:[Int])->[Int]{
    let arrayCount = array.count
    guard arrayCount > 0 else {
        return []
    }
    if arrayCount == 1 {
        return array
    }
    var result = array
    var gap = array.count / 2
    
    while gap > 0 {
        
        for index in gap..<array.count {
            
            var sequenceIndex = index
            let insertValue = result[index]
            print("at \(gap..<array.count),sequenceIndex is \(sequenceIndex),insertValue is \(insertValue)，result is \(result)")
            
            while sequenceIndex - gap >= 0 && result[sequenceIndex-gap] > insertValue {
                print("gap is \(gap),result is \(result)。at sequenceIndex \(sequenceIndex) value is \(result[sequenceIndex]), at sequenceIndex - gap \(sequenceIndex-gap) value is \(result[sequenceIndex-gap])")
                result[sequenceIndex] = result[sequenceIndex - gap]
                sequenceIndex = sequenceIndex - gap
            }
            if sequenceIndex != index {
                result[sequenceIndex] = insertValue
            }
        }
        
        gap = gap / 2
    }
    
    return result
}

print(xierSort(randomArray15))



//4.快速排序。快速排序的原理是使用一个基准，然后对比数组中的值，使基准左侧的值都小于该基准，使基准右侧的值都大于该基准。（left、right是为了加速分离数组中的值）。这样，基准本身顺序是正取的，然后将基准左右两侧按照上述方式继续排序（递归执行）。
/*（1）建立一个基准p。除去基准外的部分，从数组的最左侧选取一个左坐标left，从数组的最右侧选取一个右坐标right。
（2）left开始向右移动，将其对应的元素与基准比较；
 （3）如果left==right，此次比较结束。如果此时left处的元素比基准p大，就将p和left交换位置，然后p左右和右侧的再次执行同样的排序；否则p不动，将p左右的再次执行排序。
 （4）如果left有大于基准的，将right向左移动；
 （5）如果right有小于基准的，就将left和right交换；
 （6）如果出现left==right，执行（3）
 （7）交换完成之后，继续将left向右移动；继续执行（2）-（5）
*/
func quickSort(_ array:[Int])-> [Int] {
    
    var result = array
    
    if result.count == 1 {
        return result
    }else if result.count == 2 {
        if result.first! > result.last! {
            (result[0],result[1]) = (result[1],result[0])
        }
        return result
    }else {
        let baseValue = result.last!
        var rightIndex = result.endIndex-2
        var leftIndex = 0

        outerLoop: for leftCheckIndex in 0...result.endIndex-2 {
             leftIndex = leftCheckIndex
            
            func recurveForSubArray() {
                if result[leftIndex] > baseValue {
                    (result[leftIndex],result[result.endIndex-1]) = (result[result.endIndex-1],result[leftIndex])
                    result = (leftIndex > 0 ? quickSort(Array.init(result[0...leftIndex-1])) : []) + [baseValue] + (leftIndex < result.endIndex-1 ?   quickSort(Array.init(result[leftIndex+1...result.endIndex-1])) : [])
                }else {
                    result = quickSort(Array.init(result[0...leftIndex])) + [baseValue]
                }
            }
            
            print("loop for left index \(leftIndex),rightIndex is \(rightIndex) ,result is \(result)")
            if leftIndex == rightIndex {
                print("sort from left leftIndex == rightIndex at \(leftIndex) will exchange baseValue and found value ,result =\(result)")
                recurveForSubArray()
                break
            }else {
                
                if result[leftIndex] > baseValue {
                    print("at leftIndex \(leftIndex)  value \(result[leftIndex]) > baseValue \(baseValue) will sort from right \((leftIndex...result.endIndex-2))")

                    for rightCheckIndex in (leftIndex...rightIndex).reversed()  {
                        rightIndex = rightCheckIndex
                        print("loop for right index \(rightIndex),result is \(result)")
                        if rightIndex == leftIndex {
                            print("sort from right leftIndex == rightIndex at \(leftIndex),will exchange baseValue and found value ,result =\(result)")
                            recurveForSubArray()
                            break outerLoop
                        }
                        if result[rightIndex] < baseValue {
                            print("at rightIndex \(rightIndex)  rightValue \(result[rightIndex]) < baseValue \(baseValue) will exchange left and right value ,result =\(result)")
                            (result[leftIndex],result[rightIndex]) = (result[rightIndex],result[leftIndex])
                            break
                        }
                    }
                }
            }
        }
        
    }
    
    return result
}

print(quickSort(randomArray15))





//3.插入排序。
func insertSort(_ array:[Int]) -> [Int] {
    var result = array
    for sortIndex in 1..<result.count {
        let sortValue = result[sortIndex]
        var compareIndex = sortIndex
        //3.1使用取中值的方式来重排（时间复杂度低）
//        var compareIndexArray = 0...sortIndex-1
//        var targetIndex = (compareIndexArray.first! + compareIndexArray.last!)/2
//        while compareIndexArray.count > 0 {
//            if compareIndexArray.count == 1 {
//                if result[compareIndexArray.first!] > sortValue {
//                    targetIndex = compareIndexArray.first!
//                }else {
//                    targetIndex = compareIndexArray.first! + 1
//                }
//                break
//            }else {
//                if sortValue > result[targetIndex] {
//                    compareIndexArray = targetIndex+1...compareIndexArray.last!
//                }else {
//                    compareIndexArray = compareIndexArray.first!...targetIndex
//                }
//                targetIndex = (compareIndexArray.first! + compareIndexArray.last!)/2
//            }
//        }
//
//        if targetIndex != sortIndex {
//            result.remove(at: sortIndex)
//            result.insert(sortValue, at: targetIndex)
//        }
        
        //3.2使用交换比较的方式重排，时间复杂度较高；
        for targetIndex in (0...sortIndex-1).reversed() {
            if sortValue < result[targetIndex] {
                (result[targetIndex],result[compareIndex]) = (sortValue,result[targetIndex])
                compareIndex = targetIndex
            }else{
                break
            }
        }
    }
    
  return result
}


print(insertSort(randomArray10))


//2.冒泡排序。时间复杂度O(N2)，将一个数组变为一个升序的数组

func sortFor(_ array:[Int]) -> [Int]{
    var result = array
    for sortIndex in (1..<array.count).reversed() {
        for compareIndex in 0..<sortIndex {
            if result[compareIndex] > result[compareIndex + 1] {
                (result[compareIndex],result[compareIndex + 1]) = (result[compareIndex+1],result[compareIndex])
            }
        }
    }
    return result
}


//1.选择排序。时间复杂度O(N2)，将一个数组变为一个升序的数组
func chooseSort(_ array:[Int])->[Int] {
    guard array.isEmpty == false else {
        return []
    }
    var result = array
    
    for i in 0..<array.count-1 {
        var minimumValueIndex = i
        var miniValue = result[minimumValueIndex]
        for index in i+1..<array.count {
            if result[index] < miniValue {
                minimumValueIndex = index
                miniValue = result[minimumValueIndex]
            }
        }
        print("for index \(i), minimumValueIndex is \(minimumValueIndex) ,miniValue is \(miniValue) ")
        if minimumValueIndex != i {
            result[minimumValueIndex] = result[i]
            result[i] = miniValue
        }
    }
        
    return result
}


let sortedArray10 = chooseSort(randomArray10)
print(randomArray10)
print(sortedArray10)


