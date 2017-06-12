
import Foundation
import MapKit

class SpotifyTrackAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var spotifyTrackPartial: SpotifyTrackPartial
    
    init(coordinate: CLLocationCoordinate2D, spotifyTrackPartial: SpotifyTrackPartial) {
        
        self.coordinate           = coordinate
        self.spotifyTrackPartial  = spotifyTrackPartial
    }
}

