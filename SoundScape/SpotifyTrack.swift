
import Foundation
import Firebase



struct SpotifyTrack {

    let artist: String
    let duration: Double
    let spotifyId: String
    let isPlayable: Bool
    let name: String
    let uri: String
    let id: String
    let albumName: String
    let albumSpotifyId: String
    let largestAlbumCoverURL: String
    let smallestAlbumCoverURL: String
    let albumUri: String
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]

        artist                      = snapshotValue["artist"] as! String
        duration                    = snapshotValue["durationMs"] as! Double
        spotifyId                   = snapshotValue["spotifyId"] as! String
        isPlayable                  = snapshotValue["isPlayable"] as! Bool
        name                        = snapshotValue["name"] as! String
        uri                         = snapshotValue["uri"] as! String
        id                          = snapshotValue["id"] as! String
        albumName                   = snapshotValue["albumName"] as! String
        albumSpotifyId              = snapshotValue["albumSpotifyId"] as! String
        largestAlbumCoverURL        = snapshotValue["largestAlbumCoverURL"] as! String
        smallestAlbumCoverURL       = snapshotValue["smallestAlbumCoverURL"] as! String
        albumUri                    = snapshotValue["albumUri"] as! String
    }
    
    init(track: SPTTrack) {
        
        let spotifyArtist = track.artists[0] as! SPTPartialArtist
        let spotifyAlbum = track.album!
        let spotifyUri = track.uri.absoluteString
        
        artist                  = spotifyArtist.name
        duration                = track.duration
        spotifyId               = track.identifier
        isPlayable              = track.isPlayable
        name                    = track.name
        uri                     = spotifyUri
        id                      = ""
        albumName               = spotifyAlbum.name
        albumSpotifyId          = spotifyAlbum.identifier
        largestAlbumCoverURL    = spotifyAlbum.largestCover.imageURL.absoluteString
        smallestAlbumCoverURL   = spotifyAlbum.smallestCover.imageURL.absoluteString
        albumUri                = spotifyAlbum.uri.absoluteString
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
            "albumName": albumName,
            "albumSpotifyId": albumSpotifyId,
            "largestAlbumCoverURL": largestAlbumCoverURL,
            "smallestAlbumCoverURL": smallestAlbumCoverURL,
            "albumUri": albumUri
        ]
    }
    
    var albumArtistDisplay: String {
        return "\(self.artist) / \(self.albumName)"
    }
    
}

