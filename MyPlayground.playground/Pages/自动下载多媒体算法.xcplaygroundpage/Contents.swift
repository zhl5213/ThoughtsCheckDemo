//: [Previous](@previous)

import Foundation

//var str = "Hello, playground"
//
//var strArray = ["33","ahah","55","31223"]
//let count = min(strArray.count, 3)
//var first3 = strArray.prefix(count)
//strArray.removeFirst(count)
//print("strArray is \(strArray),first3 is \(first3)")


struct MediaInfo {
    var mediaID:String
    var creatTime:Int64
}


struct MediaDownloadRecordInfo{
    var downloadingMediaInfos:[MediaInfo]?
    var lastCompletedMedia:MediaInfo?
    var resumeMediaInfos:[MediaInfo]?
    var allRecordMedias:[MediaInfo] {
        return (downloadingMediaInfos ?? []) + (resumeMediaInfos ?? []) + (lastCompletedMedia != nil ? [lastCompletedMedia!] : [])
    }
    init() {
        
    }
}


struct SequenceSerializer {
    var length:Int
    var needDownloadMediaInfo:[MediaInfo]
    var downloadRecorder:MediaDownloadRecordInfo?
    
    init(length:UInt,needDownloadMediaInfo:[MediaInfo],downloadRecorder:MediaDownloadRecordInfo) {
        self.length = Int(length)
        self.needDownloadMediaInfo = needDownloadMediaInfo
        self.downloadRecorder = downloadRecorder
        resetInfo()
    }
    
    
    mutating func resetInfo() -> () {
        guard needDownloadMediaInfo.count > 0 else {
            return
        }
        
        let count = min(length, needDownloadMediaInfo.count)
        
        if let allRecordMedias  = downloadRecorder?.allRecordMedias,allRecordMedias.count > 0
        {
            let ascendRecordMedias = allRecordMedias.sorted(by: { $0.creatTime < $1.creatTime })
            print("before transfer ,ascendRecordMedias is \(ascendRecordMedias), needDownloadMediaInfo is \(needDownloadMediaInfo)\n")
            
            if ascendRecordMedias.last!.creatTime < needDownloadMediaInfo.first!.creatTime {
                
                downloadRecorder?.downloadingMediaInfos = Array.init(needDownloadMediaInfo.prefix(count))
                needDownloadMediaInfo.removeFirst(count)
                print("ascendRecordMedias last media create time 小于 needDownloadMediaInfo 's first.downloadingMediaInfos is \(downloadRecorder?.downloadingMediaInfos),needDownloadMediaInfo is \(needDownloadMediaInfo)\n")
                
            }else if ascendRecordMedias.first!.creatTime > needDownloadMediaInfo.last!.creatTime {
                
                downloadRecorder?.downloadingMediaInfos = nil
                
                print("ascendRecordMedias first media create time 大于 needDownloadMediaInfo 's last.downloadingMediaInfos is \(downloadRecorder?.downloadingMediaInfos),needDownloadMediaInfo is \(needDownloadMediaInfo)\n")

            }else {
                
                var currentNeedDownloadMedias = [MediaInfo]()
                if let newStartIndex = needDownloadMediaInfo.firstIndex(where: { $0.creatTime > ascendRecordMedias.last!.creatTime }) {
                    currentNeedDownloadMedias = Array.init(needDownloadMediaInfo.dropFirst(newStartIndex))
                    print("last download 和当前需要下载的有交集。 after remove downloaded medias,needDownloadMediaInfo is \(currentNeedDownloadMedias) \n")
                }
                
                var notCompletedMedias = ((downloadRecorder?.downloadingMediaInfos ?? []) + (downloadRecorder?.resumeMediaInfos ?? [])).sorted(by: { $0.creatTime < $1.creatTime })
                print("last download 和当前需要下载的有交集。last notCompletedMedias is \(notCompletedMedias)\n")
                if notCompletedMedias.count > 0 {
                    for index in (0..<notCompletedMedias.count).reversed() {
                        let notCompleteM = notCompletedMedias[index]
                        if needDownloadMediaInfo.contains(where: { $0.mediaID == notCompleteM.mediaID }) == false {
                            notCompletedMedias.remove(at: index)
                        }
                    }
                }
                print("last download 和当前需要下载的有交集。after remove not exist, notCompletedMedias is \(notCompletedMedias)\n")

                if notCompletedMedias.count < length {
                    if currentNeedDownloadMedias.count > 0  {
                        let needAddCount = min(length - notCompletedMedias.count, currentNeedDownloadMedias.count)
                        notCompletedMedias.append(contentsOf: currentNeedDownloadMedias.prefix(needAddCount))
                        currentNeedDownloadMedias.removeFirst(needAddCount)
                        print("last download 和当前需要下载的有交集。未完成的多媒体数量少余\(length) after add new need download, downloadingMediaInfos is \(notCompletedMedias)\n")
                    }
                }else if notCompletedMedias.count > length {
                    let exchangedCount = notCompletedMedias.count - length
                    currentNeedDownloadMedias.insert(contentsOf: notCompletedMedias.suffix(exchangedCount), at: 0)
                    notCompletedMedias.removeLast(exchangedCount)
                    print("last download 和当前需要下载的有交集。未完成的多媒体数量多余\(length)。after delete new need download, downloadingMediaInfos is \(notCompletedMedias)\n")
                }
                
                needDownloadMediaInfo = currentNeedDownloadMedias
                downloadRecorder?.downloadingMediaInfos = notCompletedMedias
                print("last download 和当前需要下载的有交集。最终 needDownloadMediaInfo is \(needDownloadMediaInfo)\n")

            }
            
        }else {
            downloadRecorder?.downloadingMediaInfos = Array.init(needDownloadMediaInfo.prefix(count))
            needDownloadMediaInfo.removeFirst(count)
        }
    }
    
}


var needDownloadMediaInfo = [MediaInfo]()
var lastCompletedMedia:MediaInfo?
var resumedMediaInfo:[MediaInfo]?
var downloadingMedias:[MediaInfo]?
let mediaCount = 15
var basicTime:Int64 = 1000

for i in 0..<mediaCount {
    basicTime += Int64(arc4random() % 20)
    let mediaInfo = MediaInfo.init(mediaID: "video/\(i)", creatTime: basicTime)
    needDownloadMediaInfo.append(mediaInfo)
}


var lastDownloadingMedias = needDownloadMediaInfo
//lastCompletedMedia = lastDownloadingMedias.remove(at: (0..<mediaCount).randomElement()!)
//resumedMediaInfo = [lastDownloadingMedias.remove(at:(0..<mediaCount-1).randomElement()!)]
//downloadingMedias = [lastDownloadingMedias.remove(at:(0..<mediaCount-2).randomElement()!)]
//lastCompletedMedia = lastDownloadingMedias[5]
//resumedMediaInfo = [lastDownloadingMedias[2]]
//downloadingMedias = [lastDownloadingMedias[10]]

var recorder = MediaDownloadRecordInfo.init()
recorder.downloadingMediaInfos = downloadingMedias
recorder.lastCompletedMedia = lastCompletedMedia
recorder.resumeMediaInfos = resumedMediaInfo

print("last downloadingMediaInfos is \(recorder.downloadingMediaInfos),lastCompletedMedia is \(lastCompletedMedia),resumedMediaInfo is \(resumedMediaInfo)\n")
needDownloadMediaInfo.removeFirst(7)
print("needDownloadMediaInfo is \(needDownloadMediaInfo)\n")

let sequncenSerializer = SequenceSerializer.init(length: 1, needDownloadMediaInfo: needDownloadMediaInfo, downloadRecorder: recorder)
print("new downloadingMediaInfos is \(sequncenSerializer.downloadRecorder?.downloadingMediaInfos)")









