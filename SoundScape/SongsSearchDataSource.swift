
import Foundation
import Firebase
import GeoFire

class SongsSearchDataSource {
    
    var spotifyTracks: [SpotifyTrack]?
    var ref = FirebaseService.baseRef.child(FirebaseService.FirebasePaths.songs.rawValue)

    func loadSpotifySearchQueryData(query: String, completion: @escaping (Bool) -> ()) {
        
        SpotifyApiTask.readSpotifyTrackSearch(query: query).continueOnSuccessWith { tracks in
            
            self.spotifyTracks = tracks
            completion(true)
        }
    }
    
    //save song to firebase at correct location
    public func saveSongToLocation(spotifyTrack: SpotifyTrackExtended, coordinate: CLLocationCoordinate2D) {

        let spotifyManager = SpotifyManager.sharedInstance
        let user = spotifyManager.currentUser
        
        let key = ref.childByAutoId().key
        let userKey = user?.canonicalUserName ?? ""
        ref.child(key).setValue(SoundScapeTrack.toAnyObject(track: spotifyTrack.track, userKey: userKey, key: key))

        let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.FirebasePaths.songLocations.rawValue))
    
        geoFire?.setLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), forKey: key)
    }
}
