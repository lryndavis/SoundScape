
import Foundation
import Firebase
import Unbox

// simplified track object for persisting info in firebase
//TODO: change spotify id info 
struct SoundScapeTrack {
    
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
    
    static func toAnyObject(track: SpotifyTrack, userKey: String, key: String) -> Any {
        
        return [
            "name": track.name,
            "uri": track.uri,
            "placedByUser": userKey,
            "id": key
        ]
    }
    
    //for temporary use only
    var spotifyId: String {
        
        var id = String()
        
        if let range = self.uri.range(of: "spotify:track:") {
            id = self.uri.substring(from: range.upperBound)
        }
        return id
    }
}
