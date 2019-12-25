import Foundation


public typealias HTTPHeaders = [String: String]

public protocol EndPointType {
    var url: URL {get}
    var path: String {get}
    var urlParams: URLSearchParams {get}
    var method: HTTPMethod {get}
    var headers: HTTPHeaders {get}
    var bodyEncoder: BodyEncoding {get}
}

public extension EndPointType {
    var path: String {
        return ""
    }
    var urlParams: URLSearchParams {
        return URLSearchParams()
    }
    var headers: HTTPHeaders {
        return [:]
    }
}
