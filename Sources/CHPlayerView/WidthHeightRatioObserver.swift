import Foundation
import CoreGraphics

class WidthHeightRatioObserver: NSObject {
    
    let closure: (CGFloat) -> Void
    
    init(closure: @escaping (CGFloat) -> Void) {
        self.closure = closure
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let change = change ?? [:]
        guard let new = change[NSKeyValueChangeKey.newKey] as? CGSize else {
            return
        }
        if new.width == 0 || new.height == 0 {
            return
        }
        doInMainThread {
            self.closure(new.width / new.height)
        }
    }

}
