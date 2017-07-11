
import Foundation

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
    
}
