
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
    fileprivate func setupView() {

        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContainerStackView = UIStackView()
        verticalContainerStackView.axis = .vertical
        view.addSubview(verticalContainerStackView)

        verticalContainerStackView.anchorSidesTo(view)
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(16, 24, 16, 24)
        
        let horizontalContainerStackView = UIStackView()
        horizontalContainerStackView.axis = .horizontal
        
        let secondaryVerticalStackView = UIStackView()
        secondaryVerticalStackView.axis = .vertical
        
        artistLabel.textColor = UIColor.white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 18.0)
        songLabel.textColor = UIColor.white
        songLabel.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
        secondaryVerticalStackView.addArrangedSubview(artistLabel)
        secondaryVerticalStackView.addArrangedSubview(songLabel)

        pausePlayButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        pausePlayButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        verticalContainerStackView.addArrangedSubview(pausePlayButton)
        
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(secondaryVerticalStackView)
        horizontalContainerStackView.addArrangedSubview(pausePlayButton)
    }
    
    func setQueue(queue: [SpotifyTrackPartial]) {
        spotifyAudioPlayer.playerQueue = queue
    }

    //TODO: temporary implementation; will update UI
    func setButtonPlay() {
        pausePlayButton.setTitle(">>", for: .normal)
    }
    
    //TODO: temporary implementation; will update UI
    func setButtonPause() {
        pausePlayButton.setTitle("||", for: .normal)
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
        artistLabel.text = currentSong?.artist
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
