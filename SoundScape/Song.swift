
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
    
    let artist: String
    let duration: Double
    let id: String
    let isPlayable: Bool
    let name: String
    let uri: URL
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        artist      = snapshotValue["artist"] as! String
        duration    = snapshotValue["duration_ms"] as! Double
        id          = snapshotValue["id"] as! String
        isPlayable  = snapshotValue["is_playable"] as! Bool
        name        = snapshotValue["name"] as! String
        uri         = snapshotValue["uri"] as! URL
    }
    
    init(track: SPTPartialTrack) {
        
        let spotifyArtist = track.artists[0] as! SPTPartialArtist
        
        artist      = spotifyArtist.name
        duration    = track.duration
        id          = track.identifier
        isPlayable  = track.isPlayable
        name        = track.name
        uri         = track.uri
    }
    
    func toAnyObject(track: SPTPartialTrack) -> Any {
        
        let spotifyArtist = track.artists[0] as! SPTPartialArtist
        
        return [
            "artists": spotifyArtist.name,
            "duration_ms": track.duration,
            "id": track.identifier,
            "isPlayable": track.isPlayable,
            "name": track.name,
            "uri": track.uri,
            "previewUrl": track.previewURL
        ]
    }
}

