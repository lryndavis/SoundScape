
import Foundation

enum TrackType {
    
    case sptTrackOnly
    case soundScapeTrack
}

// extended spotify track class for use throughout app 
struct SpotifyTrackExtended {
    
    let track: SpotifyTrack
    let user: SpotifyUser?
    let soundScapeId: String?
    let trackType: TrackType
    
    init(track: SpotifyTrack, user: SpotifyUser?, soundScapeId: String?, trackType: TrackType) {
        
        self.track             = track
        self.user              = user
        self.soundScapeId      = soundScapeId
        self.trackType         = trackType
    }
    
    var primaryArtist: SpotifyArtist? {
        
        return track.artists[safe: 0] 
    }
    
    var primaryArtistDisplayStr: String {
        
        return self.primaryArtist?.name ?? "Artist Unavailable"
    }
    
    var userDisplayStr: String {
        
        return self.user?.displayName ?? "User Unavailable"
    }
    
    var albumArtistDisplayStr: String {
        
        let artistName = self.primaryArtist?.name ?? "Artist Unavailable"
        let albumName = self.track.album.name 
        return "\(artistName) / \(albumName)"
    }
    
    func isFavoritedByUser(user: SoundScapeUser) -> Bool {
        
        guard let _ = user.favoritedSongs else { return false }
        
        if let id = self.soundScapeId,
            let favoriteSongsKeys = user.favoritedSongs {
            
            if favoriteSongsKeys.contains(id) {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
