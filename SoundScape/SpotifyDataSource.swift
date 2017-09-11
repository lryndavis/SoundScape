
import Foundation
import CoreLocation
import GeoFire
import Firebase
import BoltsSwift

// data source class used for all spotify queries
class SpotifyDataSource {
    
    var session: SPTSession!
    
    init() {
        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as! Data
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
    }
    
    // get SPTTrack from simplified track object
    func getSPTTrack(track: SpotifyTrack, completion: @escaping (_ track: SPTTrack) -> ()) {
        
        SPTTrack.track(withURI: URL(string: track.uri), accessToken: session.accessToken, market: nil) { error, response in
            
            if let error = error {
                print("error getting SPTTrack: \(error)")
            } else  {
                guard let spotifyTrack = response as? SPTTrack else { return }
                completion(spotifyTrack)
            }
        }
    }
    
    // get SPTUser from simplified user object
    func getSPTUser(track: SpotifyTrack, completion: @escaping (_ user: SPTUser) -> ()) {
        
        SPTUser.request(track.placedByUser, withAccessToken: session.accessToken) {
            error, response in
            if let error = error {
                print("error getting SPTUser: \(error)")
            } else {
                guard let spotifyUser = response as? SPTUser else { return }
                completion(spotifyUser)
            }
        }
    }
    
    // query firebase to find all track objects in location radius
    func getLocalTracks(location: CLLocation) -> Task<[String]> {
        
        let taskCompletionSource = TaskCompletionSource<[String]>()
        var trackKeys: [String] = []
        let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.FirebasePaths.songLocations.rawValue))
        
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
        let ref = FirebaseService.baseRef.child(FirebaseService.FirebasePaths.songs.rawValue)
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
    
}
