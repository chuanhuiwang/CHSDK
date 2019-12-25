

public protocol Requester {
    associatedtype Target
}

public extension Requester {
    
    func requestWithThrows() throws -> Self.Target {
        return try Mediator.requestWithThrows(self)
    }
    
    func requestWithFatalError() -> Self.Target {
        return Mediator.requestWithFatalError(self)
    }
    
    func request<P: DefaultProvider>(defaultProvider: P) -> Self.Target where Self.Target == P.Target {
        return Mediator.request(self, defaultProvider: defaultProvider)
    }
    
}
