import AVFoundation

class CurrentPlayerItemObserver: NSObject {
    
    let closure: (AVPlayerItem?, AVPlayerItem?) -> Void
    
    init(closure: @escaping (AVPlayerItem?, AVPlayerItem?) -> Void) {
        self.closure = closure
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let old = change?[NSKeyValueChangeKey.oldKey] as? AVPlayerItem
        let new = change?[NSKeyValueChangeKey.newKey] as? AVPlayerItem
        doInMainThread {
            self.closure(old, new)
        }
    }
    
}
