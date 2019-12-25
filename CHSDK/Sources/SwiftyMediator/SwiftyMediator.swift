

public enum Mediator {
    
    public static func requestWithThrows<R: Requester>(_ requester: R) throws -> R.Target {
        return try ThrowsMediator.request(requester)
    }
    
    public static func requestWithFatalError<R: Requester>(_ requester: R) -> R.Target {
        return FatalErrorMediator.request(requester)
    }
    
    public static func request<R: Requester, P: DefaultProvider>(_ requester: R, defaultProvider: P) -> R.Target where R.Target == P.Target {
        return DefaultProviderMediator(defaultProvider).request(requester)
    }
    
}
