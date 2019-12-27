#if os(iOS)
import UIKit
import AVFoundation

public class PlayerView: UIView {

    override public class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    public var _playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    lazy private var _player: Player = Player()
    public var player: Player {
        return _player
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public convenience init(player: Player) {
        self.init(frame: CGRect.zero)
        self._player = player
    }
    
    func setup() {
        _playerLayer.player = _player.player
    }

}

#endif
