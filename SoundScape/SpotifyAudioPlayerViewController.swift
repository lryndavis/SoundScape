
import UIKit

class SpotifyAudioPlayerViewController: UIViewController {

    let miniSpotifyAudioPlayer = MiniSpotifyAudioPlayer()
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    var spotifyAudioPlayerDelegate: SpotifyAudioPlayerDelegate?
    var halfModalTransitioningDelegate: AudioHalfModalTransitioningDelegate?
    
    @IBOutlet weak var audioPlayerButton: UIButton!
    
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
    
        self.view.bringSubview(toFront: audioPlayerButton)
    }

    func setCurrentPlayerDisplay() {
    
        if let currentTrack = spotifyAudioPlayer.currentTrack {
            miniSpotifyAudioPlayer.artistLabel.text = currentTrack.albumArtistDisplay
            miniSpotifyAudioPlayer.songLabel.text = currentTrack.name
        }
    }
    
    @IBAction func onAudioPlayerTap(_ sender: Any) {
        
        performSegue(withIdentifier: "halfModalSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "halfModalSegue" {
            super.prepare(for: segue, sender: sender)

            self.halfModalTransitioningDelegate = AudioHalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)

            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
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
