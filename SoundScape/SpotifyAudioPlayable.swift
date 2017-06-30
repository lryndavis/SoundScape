
import Foundation

protocol SpotifyAudioPlayable {
    
    var spotifyTracks: [SpotifyTrack] { get }
    var spotifyAudioPlayer: SpotifyAudioPlayer { get }
}

extension SpotifyAudioPlayable {
    
    func startNewQueueFromSelection(spotifyTrack: SpotifyTrack, isSampleSelection: Bool = false) {
        
        var newQueue = [SpotifyTrack]()

        if !isSampleSelection {
            newQueue = spotifyTracks
        }
        
        newQueue.insert(spotifyTrack, at: 0)
        spotifyAudioPlayer.trackIndex = 0
        spotifyAudioPlayer.setTrackQueue(trackQueue: newQueue)
        spotifyAudioPlayer.playTrack()
        spotifyAudioPlayer.isPlaying = true
    }
}

protocol UniversalAudioPlayerDelegate {
    
    func showAudioPlayer()
}

protocol SpotifyAudioControllable {
    
    var spotifyAudioPlayer: SpotifyAudioPlayer { get }
}

extension SpotifyAudioControllable {
    
    func setAudioPlay() {
        spotifyAudioPlayer.player?.setIsPlaying(true, callback: nil)
        spotifyAudioPlayer.isPlaying = true
    }
    
    func setAudioPause() {
        spotifyAudioPlayer.player?.setIsPlaying(false, callback: nil)
        spotifyAudioPlayer.isPlaying = false
    }
}
