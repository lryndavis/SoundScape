
import Foundation
import MapKit

class SpotifyTrackAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var spotifyTrack: SpotifyTrack
    
    init(coordinate: CLLocationCoordinate2D, spotifyTrack: SpotifyTrack) {
        
        self.coordinate           = coordinate
        self.spotifyTrack         = spotifyTrack
    }
    
    var title: String? {
        return spotifyTrack.name
    }
    
    var subtitle: String? {
        return spotifyTrack.artist
    }
    
    var isCurrentlyPlaying: Bool {
        
        let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
        if let currentSpotifyTrackId = spotifyAudioPlayer.currentTrackId {
            if self.spotifyTrack.id == currentSpotifyTrackId {
                return true
            }
        }
        return false 
    }
}

