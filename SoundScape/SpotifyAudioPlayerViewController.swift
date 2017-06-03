
import UIKit

class SpotifyAudioPlayerViewController: UIViewController {
    
    let artistLabel = UILabel()
    let songLabel = UILabel()

    let audioPlayer = SpotifyAudioPlayer()
    var playerQueue: [SpotifyTrackPartial]?
    var trackCounter: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        audioPlayer.audioPlayer?.delegate = self
        audioPlayer.audioPlayer?.playbackDelegate = self
        
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
        
        artistLabel.textColor = UIColor.white
        songLabel.textColor = UIColor.white
        
        verticalContainerStackView.addArrangedSubview(artistLabel)
        verticalContainerStackView.addArrangedSubview(songLabel)

    }
    
    func setQueue(playerQueue: [SpotifyTrackPartial]) {
        
        self.playerQueue = playerQueue
        
        playTrack(atIndex: trackCounter)
    }
    
    fileprivate func playTrack(atIndex: Int) {
        //change audio player ui properties here
        
        let currentSong = playerQueue?[atIndex]
        artistLabel.text = currentSong?.artist
        songLabel.text = currentSong?.name
        
        self.audioPlayer.audioPlayer?.playSpotifyURI(currentSong?.uri, startingWith: 0, startingWithPosition: 0, callback: { error in

            if error == nil {
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

        print("AUDIO NOW STREAMING")
        
        trackCounter += 1
        
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
