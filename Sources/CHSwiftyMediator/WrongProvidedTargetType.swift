

public struct WrongProvidedTargetType: InternalError {
    
    public let requester: Any
    public let target: Any
    public let type: Any.Type
    
    public init<R: Requester>(requester: R, target: Any) {
        self.requester = requester
        self.target = target
        self.type = R.Target.self
    }

}

extension WrongProvidedTargetType {
    
    public var localizedDescription: String {
        return "\(requester)提供的对象(\(Swift.type(of: target)): \(target))不是\(type)类型"
    }
    
}

extension WrongProvidedTargetType {
    
    public var description: String {
        return localizedDescription
    }
    
}
