import Foundation


public enum FatalErrorMediator {
    
    public static func request<R: Requester>(_ requester: R) -> R.Target {
        do {
            return try ThrowsMediator.request(requester)
        } catch {
            if let internalError = error as? InternalError {
                fatalError(internalError.description)
            }else {
                fatalError(error.localizedDescription)
            }
        }
    }
    
}
