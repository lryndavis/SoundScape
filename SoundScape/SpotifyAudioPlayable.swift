
import Foundation

protocol SpotifyAudioPlayable {
    
    var spotifyTracks: [SpotifyTrackExtended] { get }
    var spotifyManager: SpotifyManager { get }
}

extension SpotifyAudioPlayable {
    
    func startNewQueueFromSelection(sptTrack: SpotifyTrackExtended, isSampleSelection: Bool = false) {
        
        var newQueue = [SpotifyTrackExtended]()

        if !isSampleSelection {
            newQueue = spotifyTracks
        }
        
        newQueue.insert(sptTrack, at: 0)
        spotifyManager.trackIndex = 0
        spotifyManager.setTrackQueue(trackQueue: newQueue)
        spotifyManager.playTrack()
    }
}

protocol UniversalAudioPlayerDelegate {
    
    func showAudioPlayer()
}

protocol SpotifyAudioControllable {
    
    var spotifyManager: SpotifyManager { get }
}

extension SpotifyAudioControllable {
    
    func setAudioPlay() {
        spotifyManager.player?.setIsPlaying(true, callback: nil)
    }
    
    func setAudioPause() {
        spotifyManager.player?.setIsPlaying(false, callback: nil)
    }
}
