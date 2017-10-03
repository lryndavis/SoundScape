
import Foundation
import Firebase
import BoltsSwift

// handles the spotify player singleton
// grabs the current spotify user, used when adding new tracks to location 
// contains player controls such as current track info, the track queue, fast forward, rewind, and play 
class SpotifyManager {
    
    static let sharedInstance = SpotifyManager()
    
    var player = SPTAudioStreamingController.sharedInstance()
    var session: SPTSession!
    var currentUser: SoundScapeUser?
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
        
        loadCurrentUserData(completion: { [weak self] (currentUser) in
            if let strongSelf = self {
                strongSelf.currentUser = currentUser
            }
        })
    }
    
    private func loadCurrentUserData(completion: @escaping (SoundScapeUser) -> ()) {
        
        SpotifyApiTask.readCurrentSpotifyUser().continueOnSuccessWithTask { currentUser -> Task<SoundScapeUser> in
            
            return FirebaseTask.getFirebaseUser(userId: currentUser.id)
            
        }.continueOnSuccessWith { currentFirebaseUser in
                
            completion(currentFirebaseUser)
        }
    }
    
    private func initializePlayer() {
        
        do {
            try player?.start(withClientId: SpotifyAuthManager.kClientId)
            player?.login(withAccessToken: session.accessToken)
        } catch {
            print("error: failed to login to Spotify player: \(error)")
        } 
    }
    
}

extension SpotifyManager {
    
    public var currentTrack: SpotifyTrackExtended? {
        return self.trackQueue?[safe: self.trackIndex]
    }
    
    public var currentTrackId: String? {
        return self.trackQueue?[safe: self.trackIndex]?.track.id
    }
    
    public var isPlaying: Bool {
        return player?.playbackState?.isPlaying ?? false
    }

     public func playTrack() {

        if let currentTrack = self.currentTrack {
            self.player?.playSpotifyURI(currentTrack.track.uri, startingWith: 0, startingWithPosition: 0, callback: { error in
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



