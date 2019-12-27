//
//  ViewController.swift
//  iOSTest
//
//  Created by GOOUC－IOS on 2019/12/26.
//  Copyright © 2019 jiulan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var playerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerView.player.delegate = self
        let base = URL(string: "http://192.168.110.109:5500")!
        let url = base.appendingPathComponent("test.mov")
        playerView.player.set(url)
        if let queue = playerView as? QueuePlayerView {
            queue.queuePlayer.append(base.appendingPathComponent("test2.mov"))
        }
        playerView.player.play()
    }


}

extension ViewController: PlayerDelegate {
    func player(_ player: Player, widthHeightRatioDidChange ration: CGFloat) {
        print(ration)
    }
    func player(_ player: Player, playStatusDidChange status: Status) {
        print(status)
    }
    
    func player(_ player: Player, durationDidChange duration: TimeInterval) {
        print(duration)
    }
    
    func player(_ player: Player, itemLoadedTimeRangeDidChange range: RangeSet<TimeInterval>) {
        print(range)
    }
    
    func player(_ player: Player, playedDurationDidChange playedDuration: TimeInterval) {
//        print(playedDuration)
    }
}

