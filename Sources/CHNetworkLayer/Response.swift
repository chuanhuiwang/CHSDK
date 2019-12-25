import Foundation

public final class Response {
    
    public let statusCode: Int
    public let data: Data
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    
    public init(statusCode: Int, data: Data, request: URLRequest? = nil, response: HTTPURLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
    }
    
    public func decode(completion: (Result<Response, Error>) -> Void) {
        completion(Result.success(self))
    }
    
    public func decode(completion: (Result<Data, Error>) -> Void) {
        completion(Result.success(data))
    }
    
    public func decode(completion: (Result<String, Error>) -> Void) {
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            completion(Result.success(string))
        }else {
            completion(Result.failure(DecodeFailure.stringFailure))
        }
    }
    
}
