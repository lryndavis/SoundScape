
import Foundation
import MapKit

class SpotifyTrackAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var spotifyTrackExtended: SpotifyTrackExtended
    
    init(coordinate: CLLocationCoordinate2D, spotifyTrackExtended: SpotifyTrackExtended) {
        
        self.coordinate                 = coordinate
        self.spotifyTrackExtended       = spotifyTrackExtended
    }
    
    var title: String? {
        return spotifyTrackExtended.track.name
    }
    
    var subtitle: String? {
        return spotifyTrackExtended.primaryArtistDisplayStr
    }
}

