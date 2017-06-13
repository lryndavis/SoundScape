
import Foundation
import Firebase


class SpotifyTrack {

    let artist: String
    let duration: Double
    let spotifyId: String
    let isPlayable: Bool
    let name: String
    let uri: String
    let id: String
    let album: String
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]

        artist      = snapshotValue["artist"] as! String
        duration    = snapshotValue["durationMs"] as! Double
        spotifyId   = snapshotValue["spotifyId"] as! String
        isPlayable  = snapshotValue["isPlayable"] as! Bool
        name        = snapshotValue["name"] as! String
        uri         = snapshotValue["uri"] as! String
        id          = snapshotValue["id"] as! String
        album       = snapshotValue["album"] as! String
    }
    
    init(track: SPTTrack) {
        
        let spotifyArtist = track.artists[0] as! SPTPartialArtist
        let spotifyAlbum = track.album!
        let spotifyUri = track.uri.absoluteString
        
        artist      = spotifyArtist.name
        duration    = track.duration
        spotifyId   = track.identifier
        isPlayable  = track.isPlayable
        name        = track.name
        uri         = spotifyUri
        id          = ""
        album       = spotifyAlbum.name
    }
    
    func toAnyObject(key: String) -> Any {
        
        return [
            "artist": artist,
            "durationMs": duration,
            "spotifyId": spotifyId,
            "isPlayable": isPlayable,
            "name": name,
            "uri": uri,
            "id": key,
            "album": album
        ]
    }
    
    var albumArtistDisplay: String {
        return "\(self.artist) / \(self.album)"
    }
    
}

