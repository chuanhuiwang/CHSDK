import Foundation


struct Token: Encodable {
    var token = "asdfasdfhuilqwe"
}

struct Test: EndPointType {
    var url: URL {
        return URL(string: "https://www.baidu.com/api/v1/")!
    }
    var urlParams: URLSearchParams {
        return URLSearchParams(nameValues: ["name": "王传辉", "phone": "15201768391"])
    }
    var method: HTTPMethod {
        return .post
    }
    var headers: HTTPHeaders {
        return ["device": "iOS-APP"]
    }
    var bodyEncoder: BodyEncoding {
        return EncodableEncoder(encodable: Token())
    }
}

func test() {
    do {
        let request = try RequestMaker<Test>().buildRequest(Test())
        print(request)
        print(request.allHTTPHeaderFields ?? [])
        print(request.httpBody)
        print(String(data: request.httpBody ?? Data(), encoding: String.Encoding.utf8))
    }catch {
        print(error)
    }

}

