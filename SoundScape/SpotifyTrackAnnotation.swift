
import Foundation
import MapKit

// custom annotation (map pin) that contains a spotify track objects
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

