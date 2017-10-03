
import Foundation

typealias Id = String

enum SpotifyApiPath {
    
    case track (Id)
    case tracks
    case user (Id)
    case search
    case currentUser
    
    func path() -> String {
        switch self {
            
        case .track(let id):
            return "/tracks/\(id)"
        case .tracks:
            return "/tracks/"
        case .user(let id):
            return "/users/\(id)"
        case .search:
            return "/search/"
        case .currentUser:
            return "/me"
        }
    }
    
}
