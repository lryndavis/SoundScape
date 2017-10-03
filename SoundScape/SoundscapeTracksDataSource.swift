
import Foundation
import Firebase
import BoltsSwift

class SoundscapeTracksDataSource {
    
    var soundscapeTracks: [SpotifyTrackExtended]?
    
    func loadSoundscapeTracksData(userName: String, completion: @escaping (Bool) -> ()) {
        
        FirebaseTask.getSpotifyTracksPlacedByUser(userName: userName).continueOnSuccessWithTask { tracks -> Task<[SpotifyTrackExtended]> in
            
            return SpotifyApiTask.getExtendedSpotifyTracks(nearbyTracks: tracks)
            
            }.continueOnSuccessWith { extendedTracks in
                
                self.soundscapeTracks = extendedTracks
                completion(true)
        }
    }
    
}
