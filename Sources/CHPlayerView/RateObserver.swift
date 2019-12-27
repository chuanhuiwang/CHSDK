import Foundation


class RateObserver: NSObject {
    
    let closure: (Status) -> Void
    
    init(closure: @escaping (Status) -> Void) {
        self.closure = closure
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let change = change ?? [:]
        guard let rate = change[NSKeyValueChangeKey.newKey] as? Int else {
            return
        }
        if rate == 0 {
            callbackStatus(.paused)
        }else {
            callbackStatus(.playing)
        }
    }
    
    func callbackStatus(_ status: Status) {
        doInMainThread {
            self.closure(status)
        }
    }
    
}
