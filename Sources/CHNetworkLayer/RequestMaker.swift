import Foundation


public class RequestMaker<EndPoint: EndPointType> {
    
    public func buildRequest(_ endPoint: EndPoint) throws -> URLRequest {
        let url = try buildURL(endPoint)
        return try buildRequest(endPoint, url: url)
    }
    
    public func buildURL(_ endPoint: EndPoint) throws -> URL {
        var url = endPoint.url
        let path = endPoint.path
        if path.isEmpty == false {
            url.appendPathComponent(endPoint.path)
        }
        url = try add(url, urlParams: endPoint.urlParams)
        return url
    }
    
    public func buildRequest(_ endPoint: EndPoint, url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request = add(request, headers: endPoint.headers)
        request = try endPoint.bodyEncoder.encode(urlRequest: request)
        return request
    }
    
    public func add(_ url: URL, urlParams: URLSearchParams) throws -> URL {
        if urlParams.count == 0 {
            return url
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw BadURL(url: url)
        }
        components.queryItems = components.queryItems ?? []
        components.queryItems?.append(contentsOf: urlParams.queryItems)
        if components.queryItems?.isEmpty == true {
            components.queryItems = nil
        }
        guard let finalURL = components.url else {
            throw BadURLComponents(components: components)
        }
        return finalURL
    }
    
    public func add(_ urlRequest: URLRequest, headers: HTTPHeaders) -> URLRequest {
        if headers.count == 0 {
            return urlRequest
        }
        var result = urlRequest
        headers.forEach { (key, value) in
            result.setValue(value, forHTTPHeaderField: key)
        }
        return result
    }
    
}
