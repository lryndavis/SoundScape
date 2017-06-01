import Foundation
import Firebase


class SpotifyTrackPartial {

    let artist: String
    let duration: Double
    let spotifyId: String
    let isPlayable: Bool
    let name: String
    let uri: String
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]

        artist      = snapshotValue["artist"] as! String
        duration    = snapshotValue["durationMs"] as! Double
        spotifyId   = snapshotValue["spotifyId"] as! String
        isPlayable  = snapshotValue["isPlayable"] as! Bool
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
    }
    
    func toAnyObject() -> Any {
        
        return [
            "artist": artist,
            "durationMs": duration,
            "spotifyId": spotifyId,
            "isPlayable": isPlayable,
            "name": name,
            "uri": uri
        ]
    }
}

