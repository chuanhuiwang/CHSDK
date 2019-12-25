

public struct DefaultProviderMediator<P: DefaultProvider> {
    
    public let provider: P
    
    public init(_ provider: P) {
        self.provider = provider
    }
    
    public func request<R: Requester>(_ requester: R) -> R.Target where R.Target == P.Target {
        do {
            return try ThrowsMediator.request(requester)
        } catch {
            return provider.provideDefaultTarget()
        }
    }
    
}
