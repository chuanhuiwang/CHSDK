import AVFoundation


class LoadedTimeRangeHandler: NSObject {

    var oldRanges: [NSValue] = []
    var range: RangeSet<TimeInterval> = RangeSet()
    let queue = DispatchQueue.init(label: "LoadedTimeRangeHandlerQueue")
    let closure: (RangeSet<TimeInterval>) -> Void
    
    init(closure: @escaping (RangeSet<TimeInterval>) -> Void) {
        self.closure = closure
    }
    
    deinit {
        print(self, "deinit")
    }
    
    func handleLoadedTimeRange(_ ranges: [NSValue]) {
        queue.async {[weak self] in
            self?.queueHandle(ranges)
        }
        
    }
    
    func queueHandle(_ ranges: [NSValue]) {
        if ranges == oldRanges {
            return
        }
        oldRanges = ranges
        ranges.forEach { (value) in
            guard let range = value as? CMTimeRange else {
                return
            }
            let lower = range.start.seconds
            let upper = lower + range.duration.seconds
            let value = RangeSet<TimeInterval>.Range(uncheckedBounds: (lower, upper))
            self.range.insert(value)
        }
        DispatchQueue.main.async {
            self.closure(self.range)
        }
    }
    
    func clear() {
        range = RangeSet()
    }
    
}
