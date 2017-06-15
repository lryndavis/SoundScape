
import UIKit

class SpotifyAudioPlayerViewController: UIViewController {
    
    let artistLabel = UILabel()
    let songLabel = UILabel()
    let pausePlayButton = UIButton()

    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        spotifyAudioPlayer.player?.delegate = self
        spotifyAudioPlayer.player?.playbackDelegate = self
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        spotifyAudioPlayer.isPlaying ? setButtonPause() : setButtonPlay()
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

        pausePlayButton.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
        pausePlayButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        pausePlayButton.tintColor = .white
        pausePlayButton.imageView?.contentMode = .scaleAspectFit
        
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(secondaryVerticalStackView)
        horizontalContainerStackView.addArrangedSubview(pausePlayButton)
    }
    
    func setQueue(queue: [SpotifyTrack]) {
        spotifyAudioPlayer.playerQueue = queue
    }

    func setButtonPlay() {
        
        let playImage = UIImage(named: "play.png")
        let tintedPlayImage = playImage?.withRenderingMode(.alwaysTemplate)
    
        pausePlayButton.setImage(tintedPlayImage, for: .normal)
    }
    
    func setButtonPause() {
        
        let pauseImage = UIImage(named: "pause.png")
        let tintedPauseImage = pauseImage?.withRenderingMode(.alwaysTemplate)
        
        pausePlayButton.setImage(tintedPauseImage, for: .normal)
    }
    
    func togglePlay() {
        
        if spotifyAudioPlayer.isPlaying {
            spotifyAudioPlayer.player?.setIsPlaying(false, callback: nil)
            spotifyAudioPlayer.isPlaying = false
            setButtonPlay()
        } else {
            spotifyAudioPlayer.player?.setIsPlaying(true, callback: nil)
            spotifyAudioPlayer.isPlaying = true
            setButtonPause()
        }
    }
    
    func setCurrentPlayerDisplay() {
    
        let currentSong = spotifyAudioPlayer.playerQueue?[spotifyAudioPlayer.trackIndex]
        artistLabel.text = currentSong?.albumArtistDisplay
        songLabel.text = currentSong?.name
    }
    
    func playTrack(atIndex: Int) {
        
        setCurrentPlayerDisplay()

        let currentSong = spotifyAudioPlayer.playerQueue?[spotifyAudioPlayer.trackIndex]
        
        self.spotifyAudioPlayer.player?.playSpotifyURI(currentSong?.uri, startingWith: 0, startingWithPosition: 0, callback: { error in

            if error != nil {
                print("error playing track: \(String(describing: error))")
            } else {
                print("playing: \(String(describing: self.spotifyAudioPlayer.playerQueue?[self.spotifyAudioPlayer.trackIndex].name))")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SpotifyAudioPlayerViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        spotifyAudioPlayer.isPlaying = true
        setButtonPause()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        
        spotifyAudioPlayer.trackIndex += 1
        
        if let playerQueue = spotifyAudioPlayer.playerQueue {
            
            if spotifyAudioPlayer.trackIndex < playerQueue.count {
                playTrack(atIndex: spotifyAudioPlayer.trackIndex)
            } else {
                spotifyAudioPlayer.isPlaying = false
            }
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
    }
}
