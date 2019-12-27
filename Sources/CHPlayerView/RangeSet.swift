import Foundation

public struct RangeSet<Bound: Comparable> {
    
    public typealias Range = ClosedRange<Bound>
    
    private var array: [Range] = []
    
    public init() {
        
    }
    
    public var ranges: [Range] {
        return array
    }
    
    subscript(_ index: Int) -> Range? {
        if index < 0 {
            return nil
        }
        if index >= array.count {
            return nil
        }
        return array[index]
    }
    
    mutating public func insert(_ range: Range) {
        let index = findIndex(for: range)
        array.insert(range, at: index)
        var uIndex = index
        if let uRange = union(left: index - 1, right: index) {
            array.remove(at: index)
            array.remove(at: index - 1)
            array.insert(uRange, at: index - 1)
            uIndex = index - 1
        }
        if let uRange = union(left: uIndex, right: uIndex + 1) {
            array.remove(at: uIndex + 1)
            array.remove(at: uIndex)
            array.insert(uRange, at: uIndex)
        }
    }
    
    private func union(left: Int, right: Int) -> Range? {
        guard isSafeIndex(left) && isSafeIndex(right) else {
            return nil
        }
        let left = array[left]
        let right = array[right]
        if left.overlaps(right) == false {
            return nil
        }
        let lowerBound = min(left.lowerBound, right.lowerBound)
        let upperBound = max(left.upperBound, right.upperBound)
        return Range(uncheckedBounds: (lowerBound, upperBound))
    }
    
    private func isSafeIndex(_ index: Int) -> Bool {
        if index < 0 || index >= array.count {
            return false
        }
        return true
    }
    
    func findIndex(for range: Range) -> Int {
        var min = 0
        var max = array.count - 1
        var mid = 0
        while min <= max {
            mid = (min + max) / 2
            let value = array[mid]
            if range.lowerBound > value.lowerBound {
                min = mid + 1
            }else if range.lowerBound < value.lowerBound {
                max = mid - 1
            }else {
                return mid
            }
        }
        return min
    }
    
    public func forEach(body: (Range) throws -> Void) rethrows {
        try array.forEach(body)
    }
    
}


extension RangeSet: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.array == rhs.array
    }
    
}
