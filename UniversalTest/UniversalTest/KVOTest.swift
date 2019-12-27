//
//  KVOTest.swift
//  UniversalTest
//
//  Created by GOOUC－IOS on 2019/12/26.
//  Copyright © 2019 jiulan. All rights reserved.
//

import Foundation

@objc class KVOTest: NSObject {
    @objc dynamic var name: String = ""
}
@objc class Observer: NSObject {
    func dealloc() {
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(change)
    }
}



enum KVO {
    
    static func test() {
        let kvotest = KVOTest()
        var observer: Observer? = Observer()
        do {
            kvotest.addObserver(observer!, forKeyPath: "name", options: .new, context: nil)
            kvotest.name = "wang"
            kvotest.name = "chuan"
            kvotest.name = "hui"
            
        }
        kvotest.removeObserver(observer!, forKeyPath: "name")
        observer = nil
        kvotest.name = "test"
        print(kvotest)
    }
}


