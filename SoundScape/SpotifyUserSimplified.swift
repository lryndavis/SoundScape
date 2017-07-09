
import Foundation
import Firebase


struct SpotifyUser {
    
    let canonicalUserName: String
    let uri: String
    let songs: [String]?
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        canonicalUserName       = snapshotValue["canonicalUserName"] as! String
        uri                     = snapshotValue["uri"] as! String
        songs                   = snapshotValue["songs"] as? [String]
    }
    
    static func toAnyObject(trackKey: String?, user: SPTUser) -> Any {
        
        return [
            "canonicalUserName": user.canonicalUserName,
            "uri": user.uri.absoluteString,
            "songs": trackKey
        ]
    }
}
