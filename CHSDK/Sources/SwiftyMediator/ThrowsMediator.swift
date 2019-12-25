

public enum ThrowsMediator {
    
    public static func request<R: Requester>(_ requester: R) throws -> R.Target {
        guard let internalProvider = requester as? InternalProvider else {
            throw NotProviderError(requester)
        }
        let any = try internalProvider.internalProvideAny()
        guard let target = any as? R.Target else {
            throw WrongProvidedTargetType(requester: requester, target: any)
        }
        return target
    }
    
}
