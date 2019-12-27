//
//  NotificationTest.swift
//  UniversalTest
//
//  Created by GOOUC－IOS on 2019/12/26.
//  Copyright © 2019 jiulan. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let Test: Notification.Name = Notification.Name(rawValue: "NotificationTest")
    
}

enum NT {
    
    class Observer {
        
        let token: NSObjectProtocol
        let queue = OperationQueue()
        init() {
//            NotificationCenter.default.addObserver(self, selector: #selector(Observer.didGetNotification(_:)), name: Notification.Name.Test, object: nil)
            token = NotificationCenter.default.addObserver(forName: NSNotification.Name.Test, object: nil, queue: nil) { (notification) in
                print(notification)
            }
        }
        
        deinit {
            print("deinit")
        }
        
        @objc func didGetNotification(_ notification: Notification) {
            print(notification)
        }
        
    }
    
    static func main() {

        do {
            let observer = Observer()

            NotificationCenter.default.post(name: NSNotification.Name.Test, object: 1)
            NotificationCenter.default.post(name: NSNotification.Name.Test, object: 2)
            NotificationCenter.default.post(name: NSNotification.Name.Test, object: 3)
        }
        NotificationCenter.default.post(name: NSNotification.Name.Test, object: 4)
    }
}
