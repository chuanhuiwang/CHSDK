import AVFoundation


let CMTimeScaleDefault: CMTimeScale = 600


public class Player {
    
    public internal(set) var player: AVPlayer!
    public private(set) var status: Status = Status.unknown {
        didSet {
            if status == oldValue {
                return
            }
            delegate?.player(self, playStatusDidChange: status)
        }
    }
    public private(set) var range: RangeSet<TimeInterval> = RangeSet() {
        didSet {
            if range == oldValue {
                return
            }
            delegate?.player(self, itemLoadedTimeRangeDidChange: self.range)
        }
    }
    public private(set) var duration: TimeInterval = 0 {
        didSet {
            if duration == oldValue {
                return
            }
            delegate?.player(self, durationDidChange: duration)
        }
    }
    public private(set) var playedDuration: TimeInterval = 0 {
        didSet {
            if playedDuration == oldValue {
                return
            }
            delegate?.player(self, playedDurationDidChange: playedDuration)
        }
    }
    public var error: Error? {
        return player.error
    }
    
    public private(set) var widthHeightRatio: CGFloat = 1 {
        didSet {
            if self.widthHeightRatio != oldValue {
                delegate?.player(self, widthHeightRatioDidChange: self.widthHeightRatio)
            }
        }
    }
    
    private var widthHeightRatioObserver: WidthHeightRatioObserver?
    private var didEndObserver: PlayDidEndObserver?
    private var timeObserver: Any?
    private var statusObserver: StatusObserver?
    private var rateObserver: RateObserver?
    private var timeControlStatusObserver: TimeControlStatusObserver?
    private var itemDurationObserver: ItemDurationObserver?
    private var loadedTimeRangeHandler: LoadedTimeRangeHandler?
    
    
    public weak var delegate: PlayerDelegate?
    
    public init(player: AVPlayer? = nil) {
        self.player = player
        setup()
    }
    
}


 // MARK: 初始化
extension Player {
    
    @objc func setup() {
        setupPlayer()
        setupObserver()
        getLoadedTimeRangeHandler()
    }
    
    @objc func setupPlayer() {
        if self.player != nil {
            return
        }
        player = AVPlayer()
    }
    
}


 // MARK: 视频播放器操作
public extension Player {
    
    func set(_ url: URL) {
        let item = AVPlayerItem(url: url)
        set(item)
    }
    
    @objc func set(_ item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
        setupCurrentItemObserver()
        

    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func seek(to time: TimeInterval) {
        player.seek(to: CMTime(value: CMTimeValue(time), timescale: CMTimeScaleDefault))
    }
    
}



 // MARK: 观察者

extension Player {
    
    func setupObserver() {
        didEndObserver = PlayDidEndObserver(closure: {[weak self] (item) in
            self?.didEndItem(item)
        })
        setupPlayerObserver()
    }
    
    func setupCurrentItemObserver() {
        player.currentItem?.addObserver(getItemDurationObserver(), forKeyPath: #keyPath(AVPlayerItem.duration), options: [.new, .old], context: nil)
        player.currentItem?.addObserver(getWidthHeightRatioObserver(), forKeyPath: #keyPath(AVPlayerItem.presentationSize), options: [.new, .initial], context: nil)
    }
    
    func setupPlayerObserver() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScaleDefault), queue: DispatchQueue.main) {[weak self] (time) in
            self?.playedDuration = time.seconds
            self?.getLoadedTimeRangeHandler().handleLoadedTimeRange(self?.player.currentItem?.loadedTimeRanges ?? [])
        }
        player.addObserver(getStatusObserver(), forKeyPath: #keyPath(AVPlayer.status), options: .new, context: nil)
        if #available(iOS 10.0, *) {
            player.addObserver(getTimeControlStatusObserver(), forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: .new, context: nil)
        }else {
            player.addObserver(getRateObserver(), forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: nil)
        }
    }
    
}

extension Player {
    
    func itemDidChange() {
        if player.currentItem == nil {
            return
        }
        range = RangeSet()
        duration = 0
        playedDuration = 0
    }
    
    func didEndItem(_ item: AVPlayerItem) {
        if player.currentItem != item {
            return
        }
        status = .end
    }
    
    func getWidthHeightRatioObserver() -> WidthHeightRatioObserver {
        if let observer = widthHeightRatioObserver {
            return observer
        }
        let observer = WidthHeightRatioObserver {[weak self] (multiplier) in
            self?.widthHeightRatio = multiplier
        }
        widthHeightRatioObserver = observer
        return observer
    }
    
    func getStatusObserver() -> StatusObserver {
        if let observer = statusObserver {
            return observer
        }
        let statusObserver = StatusObserver {[weak self] (status) in
            if status == .readyToPlay {
                self?.duration = 0
            }
            if #available(iOS 10.0, *) {
                self?.status = status
            }else {
                let oldStatus = self?.status
                self?.status = status
                if let oldStatus = oldStatus, status == .readyToPlay, oldStatus == .playing {
                    self?.status = .playing
                }
            }
        }
        self.statusObserver = statusObserver
        return statusObserver
    }
    
    func getTimeControlStatusObserver() -> TimeControlStatusObserver {
        if let observer = timeControlStatusObserver {
            return observer
        }
        let controlObserver = TimeControlStatusObserver {[weak self] (status) in
            if self?.status == .end, status == .paused {
                
            }else {
                self?.status = status
            }
        }
        self.timeControlStatusObserver = controlObserver
        return controlObserver
    }
    
    func getRateObserver() -> RateObserver {
        if let observer = rateObserver {
            return observer
        }
        let rateObserver = RateObserver {[weak self] (status) in
            self?.status = status
        }
        self.rateObserver = rateObserver
        return rateObserver
    }
    
    func getItemDurationObserver() -> ItemDurationObserver {
        if let observer = itemDurationObserver {
            return observer
        }
        let observer = ItemDurationObserver {[weak self] (duration) in
            self?.duration = duration
        }
        itemDurationObserver = observer
        return observer
    }
    
    @discardableResult
    func getLoadedTimeRangeHandler() -> LoadedTimeRangeHandler {
        if let handler = loadedTimeRangeHandler {
            return handler
        }
        let handler = LoadedTimeRangeHandler {[weak self] (range) in
            self?.range = range
        }
        loadedTimeRangeHandler = handler
        return handler
    }
    
}





