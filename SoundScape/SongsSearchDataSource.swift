
import Foundation
import Firebase
import GeoFire

class SongsSearchDataSource {
    
    var session: SPTSession!
    var spotifyTracks: [SpotifyTrack]?
    var ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)
    
    init() {
        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as! Data
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
    }
    
    // query spotify
    func searchSpotify(query: String, completion: @escaping (_ spotifyTracks: [SpotifyTrack]) -> ()) {
        
        SPTSearch.perform(withQuery: query, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: session.accessToken) { (error, response) in
            
            if let error = error {
                print("error while searching spotify: \(error)")
            } else {
                let listpage = response as! SPTListPage
                self.getFullTracksFromPartials(listPage: listpage, completion: {
                    (spotifyTracks) in
                    completion(spotifyTracks)
                })
            }
        }
    }
    
    // get full spotify track objects from partials returned
    func getFullTracksFromPartials(listPage: SPTListPage, completion: @escaping (_ spotifyTracks: [SpotifyTrack]) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        var newtracks = [SpotifyTrack]()
        if listPage.items != nil {

            let tracks = listPage.items as! [SPTPartialTrack]
            let trackURIs = tracks.map{ $0.uri.absoluteURL }
            
            SPTTrack.tracks(withURIs: trackURIs, accessToken: session.accessToken, market: nil) { error, response in
                
                dispatchGroup.enter()
                
                if let error = error {
                    print("error when getting full tracks: \(error)")
                } else {
                    let spotifyTracks = response as! [SPTTrack]
                    
                    for track in spotifyTracks {
                        let newTrack = SpotifyTrack(track: track)
                        newtracks.append(newTrack)
                    }
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(newtracks)
                }
            }
        }
    }
    
    //save song to firebase at correct location
    func saveSongToLocation(song: SpotifyTrack, coordinate: CLLocationCoordinate2D) {

        let key = ref.childByAutoId().key
        ref.child(key).setValue(song.toAnyObject(key: key))
        
        let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
    
        geoFire?.setLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), forKey: key)
    }
    
}
