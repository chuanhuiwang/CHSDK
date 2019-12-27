import AVFoundation

class ItemDurationObserver: NSObject {
    
    let closure: (TimeInterval) -> Void
    var oldDuration: CMTime?
    
    init(closure: @escaping (TimeInterval) -> Void) {
        self.closure = closure
    }
    
    func clear() {
        oldDuration = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        useChange(change ?? [:])
        if let item = object as? AVPlayerItem {
            usePlayerItem(item)
        }
    }
    
    func useChange(_ change: [NSKeyValueChangeKey: Any]) {
        //一段诡异的代码，打断点后类型转换成功，不打断点类型转换不成功。
        print("------ old")
        print(change[NSKeyValueChangeKey.oldKey]!)
        print(type(of: change[NSKeyValueChangeKey.oldKey]!))
        print(change[NSKeyValueChangeKey.oldKey] as? CMTime ?? "nil")
        print("------ new")
        print(change[NSKeyValueChangeKey.newKey]!)
        print(type(of: change[NSKeyValueChangeKey.newKey]!))
        print(change[NSKeyValueChangeKey.newKey] as? CMTime ?? "nil")
        guard let old = change[NSKeyValueChangeKey.oldKey] as? CMTime, let new = change[NSKeyValueChangeKey.newKey] as? CMTime else {
            return
        }
        if old == new {
            return
        }
        doInMainThread {
            self.closure(new.seconds)
        }
    }
    
    func usePlayerItem(_ item: AVPlayerItem) {
        if CMTIME_IS_NUMERIC(item.duration) == false {
            return
        }
        if item.duration == oldDuration {
            return
        }
        oldDuration = item.duration
        
        doInMainThread {
            self.closure(item.duration.seconds)
        }
    }
    
}
