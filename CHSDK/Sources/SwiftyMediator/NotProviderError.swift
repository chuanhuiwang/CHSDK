

public struct NotProviderError: InternalError {
    
    public let requester: Any
    
    public init(_ requester: Any) {
        self.requester = requester
    }
    
}

extension NotProviderError {
    
    public var localizedDescription: String {
        return "\(requester)不是Provider类型"
    }
    
}

extension NotProviderError {
    
    public var description: String {
        return localizedDescription
    }
    
}
