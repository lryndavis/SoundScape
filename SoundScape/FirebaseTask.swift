
import Foundation
import Unbox
import Firebase
import BoltsSwift
import CoreLocation
import GeoFire

struct FirebaseTask {
    
    // query firebase to find all track objects in location radius
    static func getLocalTracks(location: CLLocation) -> Task<[String]> {
        
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
    static func getSpotifyTracksByKey(trackKeys: [String]) -> Task<[SoundScapeTrack]> {
        
        let taskCompletionSource = TaskCompletionSource<[SoundScapeTrack]>()
        let ref = FirebaseService.baseRef.child(FirebaseService.FirebasePaths.songs.rawValue)
        let dispatchGroup = DispatchGroup()
        var nearbyTracks: [SoundScapeTrack] = []
        
        for key in trackKeys {
            
            dispatchGroup.enter()
            
            ref.child(key).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? [String: Any] {
                    
                    let newTrack = SoundScapeTrack(snapshot: snapshot)
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
    
    // get soundscape tracks placed by spotify user
    static func getSpotifyTracksPlacedByUser(userName: String) -> Task<[SoundScapeTrack]> {
        
        let taskCompletionSource = TaskCompletionSource<[SoundScapeTrack]>()
        var tracksPlacedByUser: [SoundScapeTrack] = []
        
        let ref = FirebaseService.baseRef.child(FirebaseService.FirebasePaths.songs.rawValue)
        ref.queryOrdered(byChild: "placedByUser").queryEqual(toValue: userName).observe(.value, with: { snapshot in
            
            for item in snapshot.children {
                
                let track = SoundScapeTrack(snapshot: item as! DataSnapshot)
                tracksPlacedByUser.append(track)
            }
            taskCompletionSource.trySet(result: tracksPlacedByUser)
        })
        return taskCompletionSource.task
    }
    
    // get user from firebase 
    static func getFirebaseUser(userId: String) -> Task<SoundScapeUser> {
        
        let taskCompletionSource = TaskCompletionSource<SoundScapeUser>()
        let ref = FirebaseService.baseRef.child(FirebaseService.FirebasePaths.users.rawValue)
        ref.queryOrdered(byChild: "canonicalUserName").queryEqual(toValue: userId).observe(.value, with: { snapshot in
            var matchingUsers = [SoundScapeUser]()
            for item in snapshot.children {
                if let user = SoundScapeUser(snapshot: item as! DataSnapshot) {
                    matchingUsers.append(user)
                }
            }
            let currentUser = matchingUsers.first
            if let currentUser = currentUser {
                taskCompletionSource.trySet(result: currentUser)
            }
        })
        return taskCompletionSource.task
    }
    
}
