
import UIKit

class SpotifyAudioPlayerViewController: UIViewController {

    let miniSpotifyAudioPlayer = MiniSpotifyAudioPlayer()
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    var spotifyAudioPlayerDelegate: SpotifyAudioPlayerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        miniSpotifyAudioPlayer.delegate = self
        spotifyAudioPlayer.player?.delegate = self
        spotifyAudioPlayer.player?.playbackDelegate = self
    
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        spotifyAudioPlayer.isPlaying ? miniSpotifyAudioPlayer.pausePlayButton.setButtonPause() : miniSpotifyAudioPlayer.pausePlayButton.setButtonPlay()
    }
    
    // add mini audio player view
    fileprivate func setupView() {

        let verticalContainerStackView = UIStackView()
        verticalContainerStackView.axis = .vertical
        view.addSubview(verticalContainerStackView)

        verticalContainerStackView.addArrangedSubview(miniSpotifyAudioPlayer)
        verticalContainerStackView.anchorSidesTo(view)
        
    }

    func setCurrentPlayerDisplay() {
    
        if let currentTrack = spotifyAudioPlayer.currentTrack {
            miniSpotifyAudioPlayer.artistLabel.text = currentTrack.albumArtistDisplay
            miniSpotifyAudioPlayer.songLabel.text = currentTrack.name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - MiniSpotifyAudioPlayerDelegate methods
extension SpotifyAudioPlayerViewController: MiniSpotifyAudioPlayerDelegate {
    
    func togglePlay() {
        
        if spotifyAudioPlayer.isPlaying {
            spotifyAudioPlayer.player?.setIsPlaying(false, callback: nil)
            spotifyAudioPlayer.isPlaying = false
            miniSpotifyAudioPlayer.pausePlayButton.setButtonPlay()
        } else {
            spotifyAudioPlayer.player?.setIsPlaying(true, callback: nil)
            spotifyAudioPlayer.isPlaying = true
            miniSpotifyAudioPlayer.pausePlayButton.setButtonPause()
        }
    }
}

//MARK: - SPTAudioStreamingDelegate and SPTAudioStreamingPlaybackDelegate methods
extension SpotifyAudioPlayerViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        
        spotifyAudioPlayer.isPlaying = true
        miniSpotifyAudioPlayer.pausePlayButton.setButtonPause()
        setCurrentPlayerDisplay()
        
        if let delegate = spotifyAudioPlayerDelegate {
            delegate.showAudioPlayer()
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        
        spotifyAudioPlayer.trackIndex += 1
        
        if let trackQueue = spotifyAudioPlayer.trackQueue {
            
            if spotifyAudioPlayer.trackIndex < trackQueue.count {
                setCurrentPlayerDisplay()
                spotifyAudioPlayer.playTrack(atIndex: spotifyAudioPlayer.trackIndex)
            } else {
                spotifyAudioPlayer.isPlaying = false
            }
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
    }
}
