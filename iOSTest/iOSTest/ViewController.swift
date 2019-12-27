//
//  ViewController.swift
//  iOSTest
//
//  Created by GOOUC－IOS on 2019/12/26.
//  Copyright © 2019 jiulan. All rights reserved.
//

import UIKit
import AVFoundation
import CHPlayerView
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var nextView: UIView!
    let base = URL(string: "http://192.168.110.109:5500")!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerView.player.delegate = self
        let url = base.appendingPathComponent("test.mov")
        playerView.player.set(url)
        if let queue = playerView as? QueuePlayerView {
            queue.queuePlayer.append(base.appendingPathComponent("test2.mov"))
        }
        playerView.player.play()
        
        do {
//            let player = playerView.player.player
//            print(player)
//            let layer = AVPlayerLayer(player: player)
//            print(layer)
//            layer.frame = nextView.layer.bounds
//            nextView.layer.addSublayer(layer)
        }
        
    }
    
    @IBAction func pushVC() {
        let vc = AVPlayerViewController()
        let url = base.appendingPathComponent("test.mov")
        let player = AVPlayer(url: url)
        vc.player = player
        self.navigationController?.pushViewController(vc, animated: true)
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

