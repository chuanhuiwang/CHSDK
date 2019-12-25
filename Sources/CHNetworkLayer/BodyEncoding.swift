import Foundation

public protocol BodyEncoding {
    func encode(urlRequest: URLRequest) throws -> URLRequest
}


public struct URLEncoder: BodyEncoding {
    
    public let params: [String : Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    public func encode(urlRequest: URLRequest) throws -> URLRequest {
        var result = urlRequest
        var search = URLSearchParams()
        params.forEach { (key, value) in
            if let stringConvertible = value as? CustomStringConvertible {
                search.append(name: key, value: stringConvertible.description)
            }else {
                search.append(name: key, value: "\(value)")
            }
        }
        if encodeParamsInURL(result.httpMethod ?? "GET") {
            guard let url = result.url else {
                throw ParamsEncodingFailure.missingURL
            }
            if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                components.queryItems = components.queryItems ?? []
                components.queryItems?.append(contentsOf: search.queryItems)
                result.url = components.url
            }
        }else {
            result.httpBody = search.toPercentEncodedString().data(using: String.Encoding.utf8, allowLossyConversion: false)
            if result.value(forHTTPHeaderField: "Content-Type") == nil {
                result.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
        }
        return result
    }
    
    func encodeParamsInURL(_ method: String) -> Bool {
        switch method {
        case HTTPMethod.get.rawValue, HTTPMethod.head.rawValue, HTTPMethod.delete.rawValue:
            return true
        default:
            return false
        }
    }
    
}


public struct CHJSONEncoder: BodyEncoding {
    
    public let params: [String : Any]
    public let options: JSONSerialization.WritingOptions
    
    public init(params: [String: Any], options: JSONSerialization.WritingOptions = []) {
        self.params = params
        self.options = options
    }
    
    public func encode(urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: options)
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = data
        } catch {
            throw ParamsEncodingFailure.jsonEncodingFailure(error: error)
        }
        return request
    }
    
}

public struct EncodableEncoder<E: Encodable>: BodyEncoding {
    
    public let encodable: E
    public let encoder: JSONEncoder
    
    public init(encodable: E, encoder: JSONEncoder = JSONEncoder()) {
        self.encodable = encodable
        self.encoder = encoder
    }
    
    public func encode(urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        do {
            let data = try encoder.encode(encodable)
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = data
        } catch {
            throw ParamsEncodingFailure.encodableEncodingFailure(error: error)
        }
        return request
    }
    
}
