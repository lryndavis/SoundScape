
import UIKit


class SpotifyAudioPlayerViewController: UIViewController {

    let miniSpotifyAudioPlayer = MiniSpotifyAudioPlayer()
    let spotifyManager = SpotifyManager.sharedInstance
    var spotifyAudioPlayerDelegate: UniversalAudioPlayerDelegate?
    var halfModalTransitioningDelegate: AudioHalfModalTransitioningDelegate?
    
    @IBOutlet weak var audioPlayerButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        miniSpotifyAudioPlayer.delegate = self
        spotifyManager.player?.delegate = self
        spotifyManager.player?.playbackDelegate = self

        setupView()
        setupNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setPlayButtonDisplay()
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
    
    //todo: refactor these
    func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyAudioPlayerViewController.setCurrentPlayerDisplay), name: NSNotification.Name(rawValue: "trackChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyAudioPlayerViewController.setPlayButtonDisplay), name: NSNotification.Name(rawValue: "audioModalDismissed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyAudioPlayerViewController.presentAudioModal), name: NSNotification.Name(rawValue: "showModalTriggered"), object: nil)
    }

    func setCurrentPlayerDisplay() {
    
        if let currentTrack = spotifyManager.currentTrack {
            miniSpotifyAudioPlayer.artistLabel.text = currentTrack.albumArtistDisplayStr
            miniSpotifyAudioPlayer.songLabel.text = currentTrack.track.name
        }
    }
    
    func setPlayButtonDisplay() {
        
        spotifyManager.isPlaying ? miniSpotifyAudioPlayer.pausePlayButton.setButtonPause() : miniSpotifyAudioPlayer.pausePlayButton.setButtonPlay()
    }
    
    @IBAction func onAudioPlayerTap(_ sender: Any) {
        presentAudioModal()
    }
    
    func presentAudioModal() {
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
extension SpotifyAudioPlayerViewController: MiniSpotifyAudioPlayerDelegate, SpotifyAudioControllable {
    
    func togglePlay() {
        
        if spotifyManager.isPlaying {
            setAudioPause()
            miniSpotifyAudioPlayer.pausePlayButton.setButtonPlay(animated: true)
        } else {
            setAudioPlay()
            miniSpotifyAudioPlayer.pausePlayButton.setButtonPause(animated: true)
        }
    }
}

//MARK: - SPTAudioStreamingDelegate and SPTAudioStreamingPlaybackDelegate methods
extension SpotifyAudioPlayerViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        
        let didChangePositionNotification = Notification.Name(rawValue: "didChangePositionNotification")
        let position = ["position" : position]
        NotificationCenter.default.post(name: didChangePositionNotification, object: self, userInfo: position)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {

        miniSpotifyAudioPlayer.pausePlayButton.setButtonPause()
        
        if let delegate = spotifyAudioPlayerDelegate {
            delegate.showAudioPlayer()
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "trackChanged"), object: nil)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        
        spotifyManager.trackIndex += 1
        
        if let trackQueue = spotifyManager.trackQueue {
            
            if spotifyManager.trackIndex < trackQueue.count {
                setCurrentPlayerDisplay()
                spotifyManager.playTrack()
            }
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
    }
}

