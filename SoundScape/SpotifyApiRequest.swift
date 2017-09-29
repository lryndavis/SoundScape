
import Foundation
import Alamofire

typealias ApiParams = Alamofire.Parameters
typealias ApiHeaders = [String: String]

class SpotifyApiRequest: URLRequestConvertible {
    
    enum Method: String {
        case get
        case post
        case put
        case delete
    }
    
    var endpoint: String {
        return "https://api.spotify.com/v1"
    }
    
    var method: Method {
        return .get
    }
    
    var path: String {
        return "/"
    }
    
    var headers: ApiHeaders {
        return ApiHeaders()
    }
    
    var params: ApiParams {
        return ApiParams()
    }
    
    var timeoutInterval: TimeInterval {
        return 60.0
    }
    
    var paramsEncoder: Alamofire.ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding()
        default:
            return JSONEncoding()
        }
    }
    
    var url: Foundation.URL {
        let url = Foundation.URL(string: endpoint)!
        return url.appendingPathComponent(path)
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        
        for (key, val) in headers {
            urlRequest.addValue(val, forHTTPHeaderField: key)
        }
        
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

        var request = try! URLEncoding().encode(urlRequest, with: params)
        let urlString = request.url?.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "=")
        let urlStringWithCommas = urlString?.replacingOccurrences(of: "&ids=", with: ",")
        request.url = URL(string: urlStringWithCommas!)
        
        return request
    }
}

class AuthenticatedApiRequest: SpotifyApiRequest {
    
    let session: SPTSession!
    let authToken: String

    override init() {
        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as! Data
        
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        self.authToken = session.accessToken
    }
    
    override var headers: [String : String] {
        return ["Authorization": "Bearer \(authToken)"]
    }
}

