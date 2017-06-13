
import Foundation


class SpotifyAudioPlayer {
    
    static let sharedInstance = SpotifyAudioPlayer()
    
    var player = SPTAudioStreamingController.sharedInstance()
    var session: SPTSession!
    
    var playerQueue: [SpotifyTrack]?
    var trackIndex: Int = 0
    var isPlaying = Bool()

    private init() {
        
        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as! Data
        
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        
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
