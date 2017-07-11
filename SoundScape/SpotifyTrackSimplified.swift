
import Foundation
import Firebase

// base track object for persisting info in firebase 
struct SpotifyTrack {
    
    let name: String
    let uri: String
    let placedByUser: String
    let id: String
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        name            = snapshotValue["name"] as! String
        uri             = snapshotValue["uri"] as! String
        placedByUser    = snapshotValue["placedByUser"] as! String
        id              = snapshotValue["id"] as! String
    }
    
    static func toAnyObject(track: SPTTrack, userKey: String, key: String) -> Any {
        
        return [
            "name": track.name,
            "uri": track.uri.absoluteString,
            "placedByUser": userKey,
            "id": key
        ]
    }
}
