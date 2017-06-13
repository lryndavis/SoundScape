
import Foundation
import MapKit

class SpotifyTrackAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var spotifyTrackPartial: SpotifyTrack
    
    init(coordinate: CLLocationCoordinate2D, spotifyTrackPartial: SpotifyTrack) {
        
        self.coordinate           = coordinate
        self.spotifyTrackPartial  = spotifyTrackPartial
    }
}

