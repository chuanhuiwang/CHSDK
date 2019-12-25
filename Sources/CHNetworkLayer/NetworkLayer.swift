import Foundation
import Alamofire

public class NetworkLayer<EndPoint: EndPointType> {
    
    public let maker: RequestMaker<EndPoint>
    public let manager: SessionManager
    public var defaultHTTPHeaders: HTTPHeaders
    public var defaultURLParams: URLSearchParams
    
    public init(manager: SessionManager) {
        self.manager = manager
        self.maker = RequestMaker()
        self.defaultHTTPHeaders = SessionManager.defaultHTTPHeaders
        self.defaultURLParams = URLSearchParams()
    }
    
    public func request(_ endPoint: EndPoint) {
        do {
            var url = try maker.buildURL(endPoint)
            url = try maker.add(url, urlParams: defaultURLParams)
            var request = try maker.buildRequest(endPoint, url: url)
            request = maker.add(request, headers: defaultHTTPHeaders)
            let dataRequest = manager.request(request)
        } catch {
            
        }
    }
    
}
