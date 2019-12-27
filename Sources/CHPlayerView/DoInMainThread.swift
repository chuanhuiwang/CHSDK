import Foundation
    
func doInMainThread(closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    }else {
        DispatchQueue.main.async(execute: closure)
    }
}
    

