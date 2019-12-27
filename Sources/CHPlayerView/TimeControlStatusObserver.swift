import Foundation


class TimeControlStatusObserver: NSObject {
    
    let closure: (Status) -> Void
    
    init(closure: @escaping (Status) -> Void) {
        self.closure = closure
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let change = change ?? [:]
        guard let status = change[NSKeyValueChangeKey.newKey] as? Int else {
            return
        }
        switch status {
        case 0:
            callbackStatus(.paused)
        case 1:
            callbackStatus(.waiting)
        case 2:
            callbackStatus(.playing)
        default:
            callbackStatus(.unknown)
        }
    }
    
    func callbackStatus(_ status: Status) {
        doInMainThread {
            self.closure(status)
        }
    }
    
}
