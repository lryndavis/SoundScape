
import UIKit


protocol SpotifyAudioPlayable {
    
    var spotifyAudioPlayer: SpotifyAudioPlayer { get }
}

extension SpotifyAudioPlayable {
    
    func beginNewQueueWithSelection(trackQueue: [SpotifyTrack]) {
        
        spotifyAudioPlayer.trackIndex = 0
        spotifyAudioPlayer.setTrackQueue(trackQueue: trackQueue)
        spotifyAudioPlayer.playTrack(atIndex: spotifyAudioPlayer.trackIndex)
    }
}

protocol SpotifyAudioControllable {
    
    var spotifyAudioPlayer: SpotifyAudioPlayer { get }
    var pausePlayButton: AudioPausePlayButton { get }
}

extension SpotifyAudioControllable {
    
    func togglePlay() {
        
        if spotifyAudioPlayer.isPlaying {
            spotifyAudioPlayer.player?.setIsPlaying(false, callback: nil)
            spotifyAudioPlayer.isPlaying = false
            pausePlayButton.setButtonPlay()
        } else {
            spotifyAudioPlayer.player?.setIsPlaying(true, callback: nil)
            spotifyAudioPlayer.isPlaying = true
            pausePlayButton.setButtonPause()
        }
    }
}

class SpotifyAudioPlayerViewController: UIViewController, SpotifyAudioControllable {
    
    let artistLabel = UILabel()
    let songLabel = UILabel()
    let pausePlayButton = AudioPausePlayButton()

    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        spotifyAudioPlayer.player?.delegate = self
        spotifyAudioPlayer.player?.playbackDelegate = self
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        spotifyAudioPlayer.isPlaying ? pausePlayButton.setButtonPause() : pausePlayButton.setButtonPlay()
    }
    
    // build basic view for mini audio player
    // todo: move to custom uiview
    fileprivate func setupView() {

        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContainerStackView = UIStackView()
        verticalContainerStackView.axis = .vertical
        view.addSubview(verticalContainerStackView)

        verticalContainerStackView.anchorSidesTo(view)
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16)
        verticalContainerStackView.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
        
        let horizontalContainerStackView = UIStackView()
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.distribution = .fill
        horizontalContainerStackView.alignment = .center
        horizontalContainerStackView.isLayoutMarginsRelativeArrangement = true
        
        let secondaryVerticalStackView = UIStackView()
        secondaryVerticalStackView.axis = .vertical
        
        songLabel.textColor = UIColor.white
        songLabel.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
        artistLabel.textColor = UIColor.white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 10.0)
        
        secondaryVerticalStackView.addArrangedSubview(songLabel)
        secondaryVerticalStackView.addArrangedSubview(artistLabel)
        
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(secondaryVerticalStackView)
        
        pausePlayButton.addTarget(self, action: #selector(onPausePlayButtonTap), for: .touchUpInside)
        horizontalContainerStackView.addArrangedSubview(pausePlayButton)
    }
    
    func onPausePlayButtonTap() {
        
        togglePlay()
    }
    
    func setCurrentPlayerDisplay() {
    
        let currentSong = spotifyAudioPlayer.trackQueue?[spotifyAudioPlayer.trackIndex]
        artistLabel.text = currentSong?.albumArtistDisplay
        songLabel.text = currentSong?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: SPTAudioStreamingDelegate and SPTAudioStreamingPlaybackDelegate methods
extension SpotifyAudioPlayerViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        spotifyAudioPlayer.isPlaying = true
        pausePlayButton.setButtonPause()
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
