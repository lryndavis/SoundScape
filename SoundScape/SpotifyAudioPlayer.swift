
import Foundation


class SpotifyAudioPlayer {
    
    static let sharedInstance = SpotifyAudioPlayer()
    
    var player = SPTAudioStreamingController.sharedInstance()
    var session: SPTSession!
    
    var trackQueue: [SpotifyTrack]?
    var trackIndex: Int = 0
    
    var isPlaying = Bool()

    private init() {
        
        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as? Data
    
        if let sessionDataObj = sessionDataObj {
            self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        }
        
        initializePlayer()
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

extension SpotifyAudioPlayer {
    
    public var currentTrack: SpotifyTrack? {
        return self.trackQueue?[safe: self.trackIndex]
    }
    
    public var currentTrackId: String? {
        return self.trackQueue?[safe: self.trackIndex]?.spotifyId
    }
    
     public func playTrack() {

        if let currentTrack = self.currentTrack {
            self.player?.playSpotifyURI(currentTrack.uri, startingWith: 0, startingWithPosition: 0, callback: { error in
                if error != nil {
                    print("error playing track: \(String(describing: error))")
                } else {
                    print("playing: \(String(describing: self.trackQueue?[self.trackIndex].name))")
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
    
    public func setTrackQueue(trackQueue: [SpotifyTrack]) {
        self.trackQueue = trackQueue
    }
}



