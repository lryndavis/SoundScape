
import Foundation
import BoltsSwift

class FavoriteTracksDataSource {
    
    var favoriteTracks: [SpotifyTrackExtended]?
    
    func loadFavoriteTracksData(trackKeys: [String]?, completion: @escaping (Bool) -> ()) {
        
        guard let trackKeys = trackKeys else { return }
        
        FirebaseTask.getSpotifyTracksByKey(trackKeys: trackKeys).continueOnSuccessWithTask { tracks -> Task<[SpotifyTrackExtended]> in
            
            return SpotifyApiTask.getExtendedSpotifyTracks(nearbyTracks: tracks)
            
        }.continueOnSuccessWith { extendedTracks in
            
            self.favoriteTracks = extendedTracks
            completion(true)
        }
    }
    
}
