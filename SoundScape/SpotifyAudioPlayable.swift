
import Foundation

protocol SpotifyAudioPlayable {
    
    var spotifyTracks: [SpotifyTrack] { get }
    var spotifyAudioPlayer: SpotifyAudioPlayer { get }
}

extension SpotifyAudioPlayable {
    
    func startNewQueueFromSelection(spotifyTrack: SpotifyTrack) {
            
        var newQueue = spotifyTracks
        newQueue.insert(spotifyTrack, at: 0)
        
        spotifyAudioPlayer.trackIndex = 0
        spotifyAudioPlayer.setTrackQueue(trackQueue: newQueue)
        spotifyAudioPlayer.playTrack(atIndex: spotifyAudioPlayer.trackIndex)
        spotifyAudioPlayer.isPlaying = true
    }
}

protocol SpotifyAudioPlayerDelegate {
    
    func showAudioPlayer()
}
