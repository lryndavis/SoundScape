
import Foundation
import AlamofireImage
import Alamofire
import CoreLocation
import GeoFire
import Firebase

class NearbySongsDataSource {

    // query geofire to find all songs in radius
    func queryLocalSongs(location: CLLocation, completion: @escaping (_ songData: [String]?) -> Void) {
        
        var songData: [String] = []
        let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
        
        if let geoFire = geoFire {
            
            let circleQuery = geoFire.query(at: location, withRadius: 25.0)
            
            _ = circleQuery?.observe(.keyEntered, with: { (key, location) in
                
                if let key = key {
                    songData.insert(key, at: 0)
                }
            })
            
            circleQuery?.observeReady({
                completion(songData)
            })
        }
    }
    
    // creat new track and annotation objects from returned song objects
    func returnSongsFromId(songsByKey: [String], completion: @escaping (_ nearbySongs: [SpotifyTrack], _ nearbyAnnotations: [SpotifyTrackAnnotation]) -> Void) {
        
        let ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)
        let dispatchGroup = DispatchGroup()
        var nearbySongs: [SpotifyTrack] = []
        var nearbyAnnotations: [SpotifyTrackAnnotation] = []
        
        for songId in songsByKey {
            
            dispatchGroup.enter()
            
            ref.child(songId).observeSingleEvent(of: .value, with: { snapshot in
                
                if let _ = snapshot.value as? [String: Any] {
                    
                    let newSong = SpotifyTrack(snapshot: snapshot)
                    nearbySongs.append(newSong)
                    
                    let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
                    
                    geoFire?.getLocationForKey(songId, withCallback: { (location, error) in
                        if let location = location {
                            let newAnnotation = SpotifyTrackAnnotation(coordinate: location.coordinate, spotifyTrack: newSong)
                            nearbyAnnotations.append(newAnnotation)
                        } else {
                            print("\(String(describing: error))")
                        }
                        
                        dispatchGroup.leave()
                    })
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(nearbySongs, nearbyAnnotations)
        }
    }
    
}

