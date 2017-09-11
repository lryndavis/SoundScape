
import Foundation
import CoreLocation
import GeoFire
import Firebase
import BoltsSwift

class NearbySongsDataSource: SpotifyDataSource {
    
    var spotifyTracksExtended: [SpotifyTrackExtended]?
    var spotifyTrackAnnotations: [SpotifyTrackAnnotation]?
    
    //load all nearby track objects once user location is available
    func loadNearbyTrackData(location: CLLocation, completion: @escaping (Bool) -> ()) {
        
        self.getLocalTracks(location: location).continueOnSuccessWithTask { keys -> Task<[SpotifyTrack]> in
        
            return self.getSpotifyTracksByKey(trackKeys: keys)
        
        }.continueOnSuccessWithTask { tracks -> Task<[SpotifyTrackExtended]> in
        
            return self.getExtendedSpotifyTracks(nearbyTracks: tracks)
        
        }.continueOnSuccessWithTask { extendedTracks -> Task<[SpotifyTrackAnnotation]> in
            
            self.spotifyTracksExtended = extendedTracks
            return self.getTrackAnnotations(spotifyTracksExtended: extendedTracks)
            
        }.continueOnSuccessWith { annotations in
            
            self.spotifyTrackAnnotations = annotations
            completion(true)
        }
    }
    
    // create annotations (map pins) from nearby extended track objects
    func getTrackAnnotations(spotifyTracksExtended: [SpotifyTrackExtended]) -> Task<[SpotifyTrackAnnotation]> {
        
        let taskCompletionSource = TaskCompletionSource<[SpotifyTrackAnnotation]>()
        let dispatchGroup = DispatchGroup()
        var nearbyAnnotations = [SpotifyTrackAnnotation]()
        
        for track in spotifyTracksExtended {
            
            dispatchGroup.enter()
            
            let key = track.soundScapeId
            let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.FirebasePaths.songLocations.rawValue))
            
            geoFire?.getLocationForKey(key, withCallback: { (location, error) in
                if let location = location {
                    let newAnnotation = SpotifyTrackAnnotation(coordinate: location.coordinate, spotifyTrackExtended: track)
                    nearbyAnnotations.append(newAnnotation)
                } else {
                    print("error getting locations: \(String(describing: error))")
                }
                
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            taskCompletionSource.trySet(result: nearbyAnnotations)
        }
        return taskCompletionSource.task
    }
    
}

