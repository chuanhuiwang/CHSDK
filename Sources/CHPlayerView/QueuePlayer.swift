import AVFoundation

public class QueuePlayer: Player {
    
    public internal(set) var queuePlayer: AVQueuePlayer!
    private var currentPlayerItemObserver: CurrentPlayerItemObserver?

}


 // MARK: 初始化
extension QueuePlayer {
    
    override func setup() {
        super.setup()
        queuePlayer.addObserver(getCurrentPlayerItemObserver(), forKeyPath: #keyPath(AVPlayer.currentItem), options: [.new, .old], context: nil)
    }
    
    override func setupPlayer() {
        setupQueuePlayer()
        player = queuePlayer
    }
    
    func setupQueuePlayer() {
        queuePlayer = AVQueuePlayer()
    }
    
}


 // MARK: 视频播放器操作
public extension QueuePlayer {
    
    override func set(_ item: AVPlayerItem?) {
        queuePlayer.replaceCurrentItem(with: item)
    }
    
    func items() -> [AVPlayerItem] {
        return queuePlayer.items()
    }
    
    func advanceToNextItem() {
        queuePlayer.advanceToNextItem()
    }
    
    func append(_ url: URL) {
        let item = AVPlayerItem(url: url)
        append(item)
    }
    
    func append(_ item: AVPlayerItem) {
        let last = items().last
        if canInsert(item, after: last) {
            insert(item, after: last)
        }
    }
    
    func canInsert(_ item: AVPlayerItem, after afterItem: AVPlayerItem?) -> Bool {
        return queuePlayer.canInsert(item, after: afterItem)
    }
    
    func insert(_ item: AVPlayerItem, after afterItem: AVPlayerItem?) {
        queuePlayer.insert(item, after: afterItem)
    }
    
    func remove(_ item: AVPlayerItem) {
        queuePlayer.remove(item)
    }
    
    func removeAllItems() {
        queuePlayer.removeAllItems()
    }
    
}


 // MARK: 观察者
extension QueuePlayer {
    
    func getCurrentPlayerItemObserver() -> CurrentPlayerItemObserver {
        if let currentPlayerItemObserver = currentPlayerItemObserver {
            return currentPlayerItemObserver
        }
        let observer = CurrentPlayerItemObserver {[weak self] (old, new) in
            guard let this = self else {
                return
            }
            this.itemDidChange()
            this.getItemDurationObserver().clear()
            this.getLoadedTimeRangeHandler().clear()
            old?.removeObserver(this.getItemDurationObserver(), forKeyPath: #keyPath(AVPlayerItem.duration))
            new?.addObserver(this.getItemDurationObserver(), forKeyPath: #keyPath(AVPlayerItem.duration), options: [.new, .old, .initial], context: nil)
            
            old?.removeObserver(this.getWidthHeightRatioObserver(), forKeyPath: #keyPath(AVPlayerItem.presentationSize))
            new?.addObserver(this.getWidthHeightRatioObserver(), forKeyPath: #keyPath(AVPlayerItem.presentationSize), options: [.new, .initial], context: nil)
            
            this.delegate?.queuePlayer(this, currentItemDidChange: new)

        }
        currentPlayerItemObserver = observer
        return observer
    }
    
}
