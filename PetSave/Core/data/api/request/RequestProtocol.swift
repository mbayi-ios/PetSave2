import Foundation

protocol RequestProtocol {
  //1
  var path: String { get }

  // 2
  var headers: [String: String] { get }
  var params: [String: Any] { get }

  // 3
  var urlParams: [String: String?] { get }

  // 4
  var addAuthorizationToken: Bool { get }

  // 5
  var requestType: RequestType { get }
}

extension RequestProtocol {
  var host: String {
    APIConstants.host
  }

  var addAuthorizationToken: Bool {
    true
  }

  var params: [String: Any] {
    [:]
  }

  var urlParams: [String: String?] {
    [:]
  }

  var headers: [String: String] {
    [:]
  }

  //1
  func createURLRequest(authToken: String) throws -> URLRequest {
    //2
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path

    //3
    if !urlParams.isEmpty {
      components.queryItems = urlParams.map {
        URLQueryItem(name: $0, value: $1)
      }
    }

    guard let url = components.url
    else { throw NetworkError.invalidURL }

    //4
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = requestType.rawValue

    // 5
    if !headers.isEmpty {
      urlRequest.allHTTPHeaderFields = headers
    }

    //6
    if addAuthorizationToken {
      urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
    }

    // 7
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

    //8
    if !params.isEmpty {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
    }
    return urlRequest
  }
}
