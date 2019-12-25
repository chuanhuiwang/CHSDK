import Foundation

struct NameRequester: Requester {
    
    typealias Target = String
    
    let id: Int
    
}

extension NameRequester: Provider {
    func provideTarget() throws -> String {
        return id.description
    }
    func internalProvideAny() throws -> Any {
        return id
    }
}

struct NameDefaultProvider: DefaultProvider {
    typealias Target = String
    
    func provideDefaultTarget() -> String {
        return "null"
    }
    
}


do {
    let result = try NameRequester(id: 1).requestWithThrows()
    print(result)
}catch {
    print(error)
    if let e = error as? NotProviderError {
        print(e.localizedDescription)
    }
}

do {
    let result = NameRequester(id: 3).request(defaultProvider: NameDefaultProvider())
    print(result)
}



do {
    let result = NameRequester(id: 2).requestWithFatalError()
    print(result)
}
