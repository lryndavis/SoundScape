
import UIKit

class SpotifyAudioPlayerViewController: UIViewController {
    
    let artistLabel = UILabel()
    let songLabel = UILabel()
    let pausePlayButton = UIButton()

    let spotifyAudioPlayer = SpotifyAudioPlayer()
    var playerQueue: [SpotifyTrackPartial]?
    var trackCounter: Int = 0
    var isPlaying = Bool()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        spotifyAudioPlayer.player?.delegate = self
        spotifyAudioPlayer.player?.playbackDelegate = self
        
        setupView()
    }
    
    fileprivate func setupView() {

        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContainerStackView = UIStackView()
        verticalContainerStackView.axis = .vertical
        view.addSubview(verticalContainerStackView)

        verticalContainerStackView.anchorSidesTo(view)
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(24, 16, 24, 16)
        
        let horizontalContainerStackView = UIStackView()
        horizontalContainerStackView.axis = .horizontal
        
        let secondaryVerticalStackView = UIStackView()
        secondaryVerticalStackView.axis = .vertical
        
        artistLabel.textColor = UIColor.white
        songLabel.textColor = UIColor.white
        
        secondaryVerticalStackView.addArrangedSubview(artistLabel)
        secondaryVerticalStackView.addArrangedSubview(songLabel)

        pausePlayButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        pausePlayButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        verticalContainerStackView.addArrangedSubview(pausePlayButton)
        
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(secondaryVerticalStackView)
        horizontalContainerStackView.addArrangedSubview(pausePlayButton)
    }
    
    func setQueue(playerQueue: [SpotifyTrackPartial]) {
        
        // set initial button state
        isPlaying ? setButtonPause() : setButtonPlay()
        
        self.playerQueue = playerQueue
        
        playTrack(atIndex: trackCounter)
    }
    
    func setButtonPlay() {
        pausePlayButton.setTitle(">>", for: .normal)
    }
    
    func setButtonPause() {
        pausePlayButton.setTitle("||", for: .normal)
    }
    
    func togglePlay() {
        
        if isPlaying {
            spotifyAudioPlayer.player?.setIsPlaying(false, callback: nil)
            isPlaying = false
            setButtonPlay()
        } else {
            spotifyAudioPlayer.player?.setIsPlaying(true, callback: nil)
            isPlaying = true
            setButtonPause()
        }
    }
    
    fileprivate func playTrack(atIndex: Int) {
        //change audio player ui properties here
        
        let currentSong = playerQueue?[atIndex]
        artistLabel.text = currentSong?.artist
        songLabel.text = currentSong?.name
        
        self.spotifyAudioPlayer.player?.playSpotifyURI(currentSong?.uri, startingWith: 0, startingWithPosition: 0, callback: { error in

            if error != nil {
                print("error playing track: \(String(describing: error))")
            } else {
                print("playing: \(String(describing: self.playerQueue?[self.trackCounter].name))")
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
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        
        trackCounter += 1
        print("track counter: \(trackCounter)")
        
        if let playerQueue = playerQueue {
            
            if trackCounter < playerQueue.count {
                playTrack(atIndex: trackCounter)
            } else {
                trackCounter = 0
                playTrack(atIndex: trackCounter)
            }
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
    }
}
