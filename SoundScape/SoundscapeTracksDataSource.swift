
import Foundation
import Firebase
import BoltsSwift

class SoundscapeTracksDataSource: SpotifyDataSource {
    
    var soundscapeTracks: [SpotifyTrackExtended]?
    
    func loadSoundscapeTracksData(userName: String, completion: @escaping (Bool) -> ()) {
        
        self.getSpotifyTracksPlacedByUser(userName: userName).continueOnSuccessWithTask { tracks -> Task<[SpotifyTrackExtended]> in
            
            return self.getExtendedSpotifyTracks(tracks: tracks)
            
            }.continueOnSuccessWith { extendedTracks in
                
                self.soundscapeTracks = extendedTracks
                completion(true)
        }
    }
    
}
