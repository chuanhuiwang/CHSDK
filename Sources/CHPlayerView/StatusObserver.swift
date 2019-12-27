import Foundation
import AVFoundation


class StatusObserver: NSObject {
    
    let closure: (Status) -> Void
    
    init(closure: @escaping (Status) -> Void) {
        self.closure = closure
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let change = change ?? [:]
        guard let new = change[NSKeyValueChangeKey.newKey] as? Int else {
            return
        }
        switch new {
        case 0:
            callback(.unknown)
        case 1:
            callback(.readyToPlay)
        case 2:
            callback(.failed)
        default:
            callback(.unknown)
        }
    }
    
    func callback(_ status: Status) {
        doInMainThread {
            self.closure(status)
        }
    }
    
}
