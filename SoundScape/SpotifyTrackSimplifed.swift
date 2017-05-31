
import Foundation
import Firebase


class Song {
    
    let title: String
    let id: String
    
    init(title: String, id: String) {
        self.id = id
        self.title = title
    }
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]

        title = snapshotValue["title"] as! String
        id = snapshot.key
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "id": id
        ]
    }
}


class SpotifyTrackSimplified {
    
    /// TODO is id set to key necessary? 
    let id: String
    let artist: String
    let duration: Double
    let spotifyId: String
    let isPlayable: Bool
    let name: String
    let uri: String
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        id          = snapshot.key
        artist      = snapshotValue["artist"] as! String
        duration    = snapshotValue["duration_ms"] as! Double
        spotifyId   = snapshotValue["id"] as! String
        isPlayable  = snapshotValue["is_playable"] as! Bool
        name        = snapshotValue["name"] as! String
        uri         = snapshotValue["uri"] as! String
    }
    
    init(track: SPTPartialTrack) {
        
        let spotifyArtist = track.artists[0] as! SPTPartialArtist
        let spotifyUri = track.uri.absoluteString
        
        artist      = spotifyArtist.name
        duration    = track.duration
        spotifyId   = track.identifier
        isPlayable  = track.isPlayable
        name        = track.name
        uri         = spotifyUri
        id          = ""
    }
    
    func toAnyObject() -> Any {
        
        return [
            "artists": artist,
            "duration_ms": duration,
            "spotifyId": spotifyId,
            "isPlayable": isPlayable,
            "name": name,
            "uri": uri,
            "id": id
        ]
    }
}

