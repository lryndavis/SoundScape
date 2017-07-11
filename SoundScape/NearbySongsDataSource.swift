
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
    
    // query firebase to find all track objects in location radius
    func getLocalTracks(location: CLLocation) -> Task<[String]> {
        
        let taskCompletionSource = TaskCompletionSource<[String]>()
        var trackKeys: [String] = []
        let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
        
        if let geoFire = geoFire {
            
            let circleQuery = geoFire.query(at: location, withRadius: 25.0)
            
            _ = circleQuery?.observe(.keyEntered, with: { (key, location) in
                
                if let key = key {
                    trackKeys.insert(key, at: 0)
                }
            })
            
            circleQuery?.observeReady({
                taskCompletionSource.trySet(result: trackKeys)
            })
        }
        return taskCompletionSource.task
    }
    
    // create simplified track objects from firebase keys returned from location query
    func getSpotifyTracksByKey(trackKeys: [String]) -> Task<[SpotifyTrack]> {
        
        let taskCompletionSource = TaskCompletionSource<[SpotifyTrack]>()
        let ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)
        let dispatchGroup = DispatchGroup()
        var nearbyTracks: [SpotifyTrack] = []
        
        for key in trackKeys {
            
            dispatchGroup.enter()
            
            ref.child(key).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? [String: Any] {
                    
                    let newTrack = SpotifyTrack(snapshot: snapshot)
                    nearbyTracks.append(newTrack)
                        
                    dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            taskCompletionSource.trySet(result: nearbyTracks)
        }
        return taskCompletionSource.task
    }

    // use simplified track objects to get SPTTracks and SPTUsers, merge these into an extended track object
    func getExtendedSpotifyTracks(nearbyTracks: [SpotifyTrack]) -> Task<[SpotifyTrackExtended]> {
        
       let taskCompletionSource = TaskCompletionSource<[SpotifyTrackExtended]>()
       var nearbyExtendedSpotifyTracks = [SpotifyTrackExtended]()
       let dispatchGroup = DispatchGroup()
        
        for nearbyTrack in nearbyTracks {
            
            dispatchGroup.enter()
            
            self.getSPTTrack(track: nearbyTrack, completion: {
                track in
                
                self.getSPTUser(track: nearbyTrack, completion: {
                    user in
                    
                    let newSpotifyTrackExtended = SpotifyTrackExtended(track: track, user: user, soundScapeId: nearbyTrack.id, trackType: .soundScapeTrack)
                    nearbyExtendedSpotifyTracks.insert(newSpotifyTrackExtended, at: 0)
                    
                    dispatchGroup.leave()
                })
            })
        }
        dispatchGroup.notify(queue: .main) {
            taskCompletionSource.trySet(result: nearbyExtendedSpotifyTracks)
        }
        return taskCompletionSource.task
    }
    
    // create annotations (map pins) from nearby extended track objects
    func getTrackAnnotations(spotifyTracksExtended: [SpotifyTrackExtended]) -> Task<[SpotifyTrackAnnotation]> {
        
        let taskCompletionSource = TaskCompletionSource<[SpotifyTrackAnnotation]>()
        let dispatchGroup = DispatchGroup()
        var nearbyAnnotations = [SpotifyTrackAnnotation]()
        
        for track in spotifyTracksExtended {
            
            dispatchGroup.enter()
            
            let key = track.soundScapeId
            let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
            
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

