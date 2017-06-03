
import Foundation


class SpotifyAudioPlayer {
    
    var audioPlayer = SPTAudioStreamingController.sharedInstance()
    var session: SPTSession!
    var isPlayingAudio: Bool = false
    
    
    init() {
        
        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as! Data
        
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        
        initializePlayer()
    }
    
    private func initializePlayer() {
        
        do {
            try audioPlayer?.start(withClientId: SpotifyAuthManager.kClientId)
            audioPlayer?.login(withAccessToken: session.accessToken)
        } catch {
            print("error: failed to login to Spotify player: \(error)")
        }
    }
    
//    func playTrack(track: SpotifyTrackPartial) {
//        
//        self.audioPlayer?.playSpotifyURI(track.uri, startingWith: 0, startingWithPosition: 0, callback: { error in
//            
//            if error == nil {
//                self.isPlayingAudio = true
//            }
//        })
//    }
//    
//    func pauseTrack() {
//        
//        self.audioPlayer?.setIsPlaying(false, callback: nil)
//    }
//    
//    func playTrack() {
//        
//        self.audioPlayer?.setIsPlaying(true, callback: nil)
//    }
//    
}
