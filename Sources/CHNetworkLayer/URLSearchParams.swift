import Foundation


public struct URLSearchParams {
    
    private var components: URLComponents
    var queryItems: [URLQueryItem] {
        return components.queryItems ?? []
    }
    
    public init() {
        self.init(components: URLComponents())
    }
    
    public init?(string: String) {
        if let components = URLComponents(string: string) {
            self.init(components: components)
        }else {
            return nil
        }
    }
    
    public init?(url: URL, resolvingAgainstBaseURL resolve: Bool) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: resolve) {
            self.init(components: components)
        }else {
            return nil
        }
    }
    
    public init(components: URLComponents) {
        self.components = components
        if self.components.queryItems == nil {
            self.components.queryItems = []
        }
    }
    
    public init(nameValues: [(String, String?)]) {
        var components = URLComponents()
        components.queryItems = []
        nameValues.forEach { (name, value) in
            components.queryItems?.append(URLQueryItem(name: name, value: value))
        }
        self.init(components: components)
    }
    
    public init(nameValues: [String: String?]) {
        var components = URLComponents()
        components.queryItems = []
        nameValues.forEach { (name, value) in
            components.queryItems?.append(URLQueryItem(name: name, value: value))
        }
        self.init(components: components)
    }
    
    public var count: Int {
        return components.queryItems?.count ?? 0
    }
    
    public mutating func append(name: String, value: String?) {
        components.queryItems?.append(URLQueryItem(name: name, value: value))
    }
    
    public mutating func delete(name: String) {
        components.queryItems = components.queryItems?.filter({$0.name != name})
    }
    
    public func entries() -> [(String, String?)] {
        return components.queryItems?.map({($0.name, $0.value)}) ?? []
    }
    
    public func get(name: String) -> String? {
        guard let firstIndex = components.queryItems?.firstIndex(where: {$0.name == name}) else {
            return nil
        }
        let item = components.queryItems?[firstIndex]
        return item?.value
    }
    
    public func getAll(name: String) -> [String] {
        let result = components.queryItems?.compactMap { (item) -> String? in
            if item.name == name {
                return item.value
            }else {
                return nil
            }
        }
        return result ?? []
    }
    
    public func has(name: String) -> Bool {
        if (components.queryItems?.firstIndex(where: {$0.name == name})) != nil {
            return true
        }else {
            return false
        }
    }
    
    public func keys() -> [String] {
        var result: [String] = []
        components.queryItems?.forEach({ (item) in
            if result.contains(item.name) == false {
                result.append(item.name)
            }
        })
        return result
    }
    
    public mutating func set(name: String, value: String?) {
        var hasSet = false
        self.components.queryItems = self.components.queryItems?.compactMap({ (item) -> URLQueryItem? in
            if item.name != name {
                return item
            }
            if hasSet {
                return nil
            }
            let result = URLQueryItem(name: name, value: value)
            hasSet = true
            return result
        })
    }
    
    public mutating func sort() {
        self.components.queryItems?.sort(by: { (left, right) -> Bool in
            return left.name < right.name
        })
    }
    
    public func toString() -> String {
        return components.query ?? ""
    }
    
    public func toPercentEncodedString() -> String {
        return components.percentEncodedQuery ?? ""
    }
    
    public func values() -> [String] {
        return self.components.queryItems?.compactMap({$0.value}) ?? []
    }
    
}
