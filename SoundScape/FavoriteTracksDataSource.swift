
import Foundation
import BoltsSwift

class FavoriteTracksDataSource: SpotifyDataSource {
    
    var favoriteTracks: [SpotifyTrackExtended]?
    
    func loadFavoriteTracksData(trackKeys: [String]?, completion: @escaping (Bool) -> ()) {
        
        guard let trackKeys = trackKeys else { return }
        
        self.getSpotifyTracksByKey(trackKeys: trackKeys).continueOnSuccessWithTask { tracks -> Task<[SpotifyTrackExtended]> in
            
            return self.getExtendedSpotifyTracks(tracks: tracks)
            
        }.continueOnSuccessWith { extendedTracks in
            
            self.favoriteTracks = extendedTracks
            completion(true)
        }
    }
    
}
