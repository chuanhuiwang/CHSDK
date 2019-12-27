import Foundation


var set = RangeSet<TimeInterval>()
set.insert(ClosedRange<TimeInterval>(uncheckedBounds: (0, 3)))
print(set)
set.insert(ClosedRange<TimeInterval>(uncheckedBounds: (4, 7)))
print(set)
set.insert(ClosedRange<TimeInterval>(uncheckedBounds: (1, 4)))
print(set)
set.insert(ClosedRange<TimeInterval>(uncheckedBounds: (8, 11)))
print(set)
set.insert(ClosedRange<TimeInterval>(uncheckedBounds: (7, 8)))
print(set)


