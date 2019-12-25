

public protocol InternalProvider {
    func internalProvideAny() throws -> Any
}

public protocol Provider: InternalProvider {
    
    associatedtype Target
    
    func provideTarget() throws -> Target
    
}

public extension InternalProvider where Self: Provider {
    
    func internalProvideAny() throws -> Any {
        return try provideTarget()
    }
    
}

public protocol DefaultProvider {
    
    associatedtype Target
    
    func provideDefaultTarget() -> Target
    
}
