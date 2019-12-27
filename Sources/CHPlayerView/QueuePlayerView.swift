#if os(iOS)
import UIKit

public class QueuePlayerView: PlayerView {
        
    lazy private var _queuePlayer: QueuePlayer = QueuePlayer()
    public override var player: Player {
        return _queuePlayer
    }
    
    public var queuePlayer: QueuePlayer {
        return _queuePlayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func setup() {
        _playerLayer.player = _queuePlayer.player
    }

}

#endif
