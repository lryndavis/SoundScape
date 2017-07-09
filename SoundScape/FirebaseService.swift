
import Foundation
import Firebase
import FirebaseDatabase


class FirebaseService {
    
    static let baseRef = Database.database().reference()
    
    enum ChildRef: String {
        case songs              = "songs"
        case songLocations      = "song_locations"
        case songUser           = "users"
    }
}

