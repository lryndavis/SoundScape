
import Foundation

// handles the spotify player singleton
// grabs the current spotify user, used when adding new tracks to location 
// contains player controls such as current track info, the track queue, fast forward, rewind, and play 
class SpotifyManager {
    
    static let sharedInstance = SpotifyManager()
    
    var player = SPTAudioStreamingController.sharedInstance()
    var session: SPTSession!
    var currentUser: SPTUser?
    var trackQueue: [SpotifyTrackExtended]?
    var trackIndex: Int = 0
    
    private init() {
        
        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as? Data
    
        if let sessionDataObj = sessionDataObj {
            self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        }
        
        initializePlayer()
        
        SpotifyManager.getCurrentUser(session: self.session, completion: {
            [weak self] (user) in
            if let strongSelf = self {
                strongSelf.currentUser = user
            }
        })
    }

    private func initializePlayer() {
        
        do {
            try player?.start(withClientId: SpotifyAuthManager.kClientId)
            player?.login(withAccessToken: session.accessToken)
        } catch {
            print("error: failed to login to Spotify player: \(error)")
        }
    }
    
    static func getCurrentUser(session: SPTSession, completion: @escaping (_ user: SPTUser) -> ()) {
     
        do {
            let userRequest: URLRequest = try SPTUser.createRequestForCurrentUser(withAccessToken: session.accessToken)
                SPTRequest.sharedHandler().perform(userRequest, callback: { (error, response, data) in
                    if error != nil {
                        print("error fetching user: \(String(describing: error))")
                    }
                    else {
                        do {
                            let user: SPTUser = try SPTUser(from: data, with: response)
                            completion(user)
                        }
                        catch {
                            print("error creating user: \(error)")
                        }
                    }
                })
            }
            catch {
                print("error fetching user: \(error)")
            }
        }
    }

extension SpotifyManager {
    
    public var currentTrack: SpotifyTrackExtended? {
        return self.trackQueue?[safe: self.trackIndex]
    }
    
    public var currentTrackId: String? {
        return self.trackQueue?[safe: self.trackIndex]?.track.identifier
    }
    
    public var isPlaying: Bool {
        return player?.playbackState?.isPlaying ?? false
    }

     public func playTrack() {

        if let currentTrack = self.currentTrack {
            self.player?.playSpotifyURI(currentTrack.track.uri.absoluteString, startingWith: 0, startingWithPosition: 0, callback: { error in
                if error != nil {
                    print("error playing track: \(String(describing: error))")
                } else {
                    print("playing: \(String(describing: self.currentTrack))")
                }
            })
        }
    }
    
    public func skipTrack() {
        
        guard let trackQueue = trackQueue else { return }
        if trackIndex < trackQueue.count {
            trackIndex += 1
            playTrack()
        }
    }
    
    public func playPreviousTrack() {
        
        if trackIndex != 0 {
            trackIndex -= 1
            playTrack()
        }
    }
    
    public func setTrackQueue(trackQueue: [SpotifyTrackExtended]) {
        self.trackQueue = trackQueue
    }
}



