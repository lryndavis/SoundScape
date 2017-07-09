
import Foundation
import Firebase
import GeoFire

class SongsSearchDataSource: SpotifyDataSource {
    
    var spotifyTracks: [SpotifyTrackExtended]?
    var ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)
    
    // query spotify
    func searchSpotify(query: String, completion: @escaping (_ spotifyTracks: [SpotifyTrackExtended]) -> ()) {
        
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
    func getFullTracksFromPartials(listPage: SPTListPage, completion: @escaping (_ spotifyTracks: [SpotifyTrackExtended]) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        var newTracks = [SpotifyTrackExtended]()
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
                        let newTrack = SpotifyTrackExtended(track: track, user: nil, soundScapeId: nil, trackType: .sptTrackOnly)
                        newTracks.append(newTrack)
                    }
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(newTracks)
                }
            }
        }
    }
    
    //save song to firebase at correct location
    func saveSongToLocation(spotifyTrack: SpotifyTrackExtended, coordinate: CLLocationCoordinate2D) {

        let spotifyManager = SpotifyManager.sharedInstance
        let user = spotifyManager.currentUser
        
        let key = ref.childByAutoId().key
        let userKey = user?.canonicalUserName ?? ""
        ref.child(key).setValue(SpotifyTrack.toAnyObject(track: spotifyTrack.track, userKey: userKey, key: key))

        let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
    
        geoFire?.setLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), forKey: key)
    }
}
