import Foundation
import CoreGraphics


public protocol PlayerDelegate: class {
    func player(_ player: Player, widthHeightRatioDidChange ration: CGFloat)
    func player(_ player: Player, playStatusDidChange status: Status)
    func player(_ player: Player, durationDidChange duration: TimeInterval)
    func player(_ player: Player, playedDurationDidChange playedDuration: TimeInterval)
    func player(_ player: Player, itemLoadedTimeRangeDidChange range: RangeSet<TimeInterval>)
}

public extension PlayerDelegate {
    
    func player(_ player: Player, widthHeightRatioDidChange ration: CGFloat) {
        
    }
    
    func player(_ player: Player, playStatusDidChange status: Status) {
        
    }
    
    func player(_ player: Player, durationDidChange duration: TimeInterval) {
        
    }
    
    func player(_ player: Player, playedDurationDidChange playedDuration: TimeInterval) {
        
    }
    
    func player(_ player: Player, itemLoadedTimeRangeDidChange range: RangeSet<TimeInterval>) {
        
    }
    
}
