
import Foundation

protocol SpotifyAudioPlayable {
    
    var spotifyTracks: [SpotifyTrack] { get }
    var audioPlayerVC: SpotifyAudioPlayerViewController { get }
    var spotifyAudioPlayer: SpotifyAudioPlayer { get }
    func showMusicPlayer()
}

extension SpotifyAudioPlayable {
    
    func startNewQueueFromSelection(spotifyTrack: SpotifyTrack) {
            
        var newQueue = spotifyTracks
        newQueue.insert(spotifyTrack, at: 0)
        
        spotifyAudioPlayer.trackIndex = 0
        spotifyAudioPlayer.setTrackQueue(trackQueue: newQueue)
        spotifyAudioPlayer.playTrack(atIndex: spotifyAudioPlayer.trackIndex)
        
        audioPlayerVC.setCurrentPlayerDisplay()
        spotifyAudioPlayer.isPlaying = true
        showMusicPlayer()
    }
}
