
import Foundation

enum TrackType {
    
    case sptTrackOnly
    case soundScapeTrack
}

// extended spotify class for use throughout app 
struct SpotifyTrackExtended {
    
    let track: SPTTrack
    let user: SPTUser?
    let soundScapeId: String?
    let trackType: TrackType
    
    init(track: SPTTrack, user: SPTUser?, soundScapeId: String?, trackType: TrackType) {
        
        self.track             = track
        self.user              = user
        self.soundScapeId      = soundScapeId
        self.trackType         = trackType
    }
    
    var primaryArtist: SPTPartialArtist? {
        
        return track.artists[safe: 0] as? SPTPartialArtist
    }
    
    var primaryArtistDisplayStr: String {
        
        return self.primaryArtist?.name ?? "Artist Unavailable"
    }
    
    var userDisplayStr: String {
        
        return self.user?.canonicalUserName ?? "User Unavailable"
    }
    
    var albumArtistDisplayStr: String {
        
        let artistName = self.primaryArtist?.name ?? "Artist Unavailable"
        let albumName = self.track.album.name ?? "Album Unavailable"
        return "\(artistName) / \(albumName)"
    }
    
    var albumCoverImageURLSmall: String? {
        
        return track.album.smallestCover.imageURL.absoluteString
    }
    
    var albumCoverImageURLLarge: String? {
        
        return track.album.largestCover.imageURL.absoluteString
    }
}
