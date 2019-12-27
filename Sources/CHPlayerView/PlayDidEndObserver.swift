import Foundation
import AVFoundation


class PlayDidEndObserver {
    
    let closure: (AVPlayerItem) -> Void
    
    init(closure: @escaping (AVPlayerItem) -> Void) {
        self.closure = closure
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let item = notification.object as? AVPlayerItem else {
                return
            }
            doInMainThread {
                self?.closure(item)
            }
        }
    }
    
}
