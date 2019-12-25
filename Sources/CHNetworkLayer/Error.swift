import Foundation

public enum ParamsEncodingFailure: Error {
    case missingURL
    case jsonEncodingFailure(error: Error)
    case encodableEncodingFailure(error: Error)
}

public enum DecodeFailure: Error {
    case stringFailure
}

public struct BadURL: Error {
    public let url: URL
    public init(url: URL) {
        self.url = url
    }
}

public struct BadURLComponents: Error {
    public let components: URLComponents
    public init(components: URLComponents) {
        self.components = components
    }
}
