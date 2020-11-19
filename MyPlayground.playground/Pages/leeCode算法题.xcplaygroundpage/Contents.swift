//: [Previous](@previous)

import Foundation





//MARK:-第1019题，链表中的下一个更大节点-
//给出一个以头节点 head 作为第一个节点的链表。链表中的节点分别编号为：node_1, node_2, node_3, ... 。

//每个节点都可能有下一个更大值（next larger value）：对于 node_i，如果其 next_larger(node_i) 是 node_j.val，那么就有 j > i 且  node_j.val > node_i.val，而 j 是可能的选项中最小的那个。如果不存在这样的 j，那么下一个更大值为 0 。
//
//返回整数答案数组 answer，其中 answer[i] = next_larger(node_{i+1}) 。
//
//注意：在下面的示例中，诸如 [2,1,5] 这样的输入（不是输出）是链表的序列化表示，其头节点的值为 2，第二个节点值为 1，第三个节点值为 5 。
//
//
//
//示例 1：
//
//输入：[2,1,5]
//输出：[5,5,0]
//示例 2：
//
//输入：[2,7,4,3,5]
//输出：[7,0,5,5,0]
//示例 3：
//
//输入：[1,7,5,1,9,2,5,1]
//输出：[7,9,9,9,0,5,0,0]
//
//提示：
//
//对于链表中的每个节点，1 <= node.val <= 10^9
//给定列表的长度在 [0, 10000] 范围内

public class ListNode {
   public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}


//1.暴力解法，时间复杂度O(N2)
//func nextLargerNodes(_ head: ListNode?) -> [Int] {
//    var largeNodes = [Int] ()
//    var computeNode = head
//
//    while let newComputeNode = computeNode {
//        var nodeLargeValue = 0
//
//        var nextNode = newComputeNode.next
//        while let newNextnode = nextNode {
//            if newNextnode.val > newComputeNode.val {
//                nodeLargeValue = newNextnode.val
//                break
//            }
////            print("get largeValue for newComputeNode \(newComputeNode.val),current Node is \(newNextnode.val),nodeLargeValue is\(nodeLargeValue)")
//            nextNode = nextNode?.next
//        }
//
////        print("get largeValue for newComputeNode \(newComputeNode.val),final LargeValue is\(nodeLargeValue)")
//        largeNodes.append(nodeLargeValue)
//
//        if newComputeNode.next == nil {
//            computeNode = nil
//        }else {
//            computeNode = newComputeNode.next
//        }
//    }
//
//    return largeNodes
//}

//优雅的解法，
func nextLargerNodes(_ head: ListNode?) -> [Int] {
    guard head != nil else {
        return []
    }
    
    var valueArray = [Int]()
    var node = head
    while let trNode = node {
        valueArray.append(trNode.val)
        node = trNode.next
    }
    
    var largeNodes = [Int] ()
    var stack = [Int]()
    
    for nodeValue in valueArray.enumerated().reversed() {
        while stack.isEmpty == false,stack.last! <= nodeValue.element {
            stack.removeLast()
        }
        let largeNode = stack.isEmpty ? 0 : stack.last!
         
        largeNodes.append(largeNode)
    }
  
    
    return largeNodes
}


let node215 = ListNode.init(2)
node215.next = ListNode.init(1)
node215.next?.next = ListNode.init(5)
print(nextLargerNodes(node215))


let node27435 = ListNode.init(2)
node27435.next = ListNode.init(7)
node27435.next?.next = ListNode.init(4)
node27435.next?.next?.next = ListNode.init(3)
node27435.next?.next?.next?.next = ListNode.init(5)
print(nextLargerNodes(node27435))


let node17519251 = ListNode.init(1)
node17519251.next = ListNode.init(7)
node17519251.next?.next = ListNode.init(5)
node17519251.next?.next?.next = ListNode.init(1)
node17519251.next?.next?.next?.next = ListNode.init(9)
node17519251.next?.next?.next?.next?.next = ListNode.init(2)
node17519251.next?.next?.next?.next?.next?.next = ListNode.init(5)
node17519251.next?.next?.next?.next?.next?.next?.next = ListNode.init(1)

print(nextLargerNodes(node17519251))


//第946道算法题：验证栈序列
//给定 pushed 和 popped 两个序列，每个序列中的 值都不重复，只有当它们可能是在最初空栈上进行的推入 push 和弹出 pop 操作序列的结果时，返回 true；否则，返回 false 。
//
//
//
//示例 1：
//
//输入：pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
//输出：true
//解释：我们可以按以下顺序执行：
//push(1), push(2), push(3), push(4), pop() -> 4,
//push(5), pop() -> 5, pop() -> 3, pop() -> 2, pop() -> 1
//示例 2：
//
//输入：pushed = [1,2,3,4,5], popped = [4,3,5,1,2]
//输出：false
//解释：1 不能在 2 之前弹出。
//
//
//提示：
//
//0 <= pushed.length == popped.length <= 1000
//0 <= pushed[i], popped[i] < 1000
//pushed 是 popped 的排列。

func validateStackSequences(_ pushed: [Int], _ popped: [Int]) -> Bool {
    guard pushed.count > 0,popped.count > 0,popped.count == pushed.count else {
        fatalError()
    }
    var newPushed = [Int]()
    var newPopped = popped
    
    outerLoop: for pushItemInfo in pushed.enumerated() {
        var pushItem = pushItemInfo.element
        if pushItem < newPopped.first! {
            newPushed.append(pushItem)
            print("pushitem < currentItem,after add newPushed Array is\(newPushed),current pushItm is \(pushItem),currentPopItem is \(newPopped.first!),newPoppedArray is \(newPopped)")
        }else if pushItem == newPopped.first! {
            newPopped.removeFirst()
            if newPopped.count == 0 {
                break
            }
            print("pushItem == popedItem. after remove, newPushed Array is\(newPushed),current pushItm is \(pushItem),currentPopItem is \(newPopped.first!),newPoppedArray is \(newPopped)")
            
            while newPopped.first! <= pushItem {
                for item in newPushed.enumerated().reversed() {
                    if item.element >= newPopped.first! {
                        pushItem = newPushed.removeLast()
                    }
                }
                newPopped.removeFirst()
                if newPopped.count == 0 {
                    break outerLoop
                }
                print("pushItem > popedItem,after remove,newPushed Array is\(newPushed),current pushItm is \(pushItem),currentPopItem is \(newPopped.first!),newPoppedArray is \(newPopped)")
            }
            if newPushed.count == 0 {
                break
            }
        }
    }
    
    return newPopped.count == 0
}

let canexcute1 = validateStackSequences([1,2,3,4,5], [4,3,5,1,2])
let canexcute2 = validateStackSequences([1,2,3,4,5], [4,3,5,2,1])
let canexcute3 = validateStackSequences([1,2,3,4,5], [1,2,5,3,4])
let canexcute4 = validateStackSequences([1,2,3,4,5], [4,5,3,2,1])
let canexcute5 = validateStackSequences([1,2,3,4,5], [4,3,2,5,1])




////1441题：用栈操作构建数组
//给你一个目标数组 target 和一个整数 n。每次迭代，需要从  list = {1,2,3..., n} 中依序读取一个数字。
//
//请使用下述操作来构建目标数组 target ：
//
//Push：从 list 中读取一个新元素， 并将其推入数组中。
//Pop：删除数组中的最后一个元素。
//如果目标数组构建完成，就停止读取更多元素。
//题目数据保证目标数组严格递增，并且只包含 1 到 n 之间的数字。
//
//请返回构建目标数组所用的操作序列。
//
//题目数据保证答案是唯一的。
//
//
//
//示例 1：
//
//输入：target = [1,3], n = 3
//输出：["Push","Push","Pop","Push"]
//解释：
//读取 1 并自动推入数组 -> [1]
//读取 2 并自动推入数组，然后删除它 -> [1]
//读取 3 并自动推入数组 -> [1,3]
//示例 2：
//
//输入：target = [1,2,3], n = 3
//输出：["Push","Push","Push"]
//示例 3：
//
//输入：target = [1,2], n = 4
//输出：["Push","Push"]
//解释：只需要读取前 2 个数字就可以停止。
//示例 4：
//
//输入：target = [2,3,4], n = 4
//输出：["Push","Pop","Push","Push","Push"]
 
//
//提示：
//
//1 <= target.length <= 100
//1 <= target[i] <= 100
//1 <= n <= 100
//target 是严格递增的

func buildArray(_ target: [Int], _ n: Int) -> [String] {
    
    guard target.count > 0 else {
        return []
    }
    
    var currentFindIndex = 0
    var currentFindTarget = target[currentFindIndex]
    var  excuteArrays = [String]()
    let pushString = "Push"
    let popString = "Pop"
    
    for sequence in 1...n {
        if currentFindTarget == sequence {
            excuteArrays.append(pushString)
            if currentFindIndex + 1 < target.endIndex {
                currentFindIndex += 1
                currentFindTarget = target[currentFindIndex]
            }else {
                break
            }
        }else if sequence < currentFindTarget {
            excuteArrays.append(contentsOf: [pushString,popString])
        }
    }
    return excuteArrays
    
}


let array2 = [1,3]
let excutes2 = buildArray(array2, 3)
print(excutes2)

let excutes3 = buildArray([1,2,3], 3)
print(excutes3)

print(buildArray([1,2], 4))

print(buildArray([2,3,4], 4))
