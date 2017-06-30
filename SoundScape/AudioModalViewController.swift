
import UIKit

class AudioModalViewController: UIViewController {
    
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    var audioHalfModalView = AudioHalfModalView()
    
    @IBOutlet weak var containerStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(AudioModalViewController.updateModalPlayerView), name: NSNotification.Name(rawValue: "trackChanged"), object: nil)
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getAlbumImage()
    }
    
    func setupView() {

        audioHalfModalView.delegate = self
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)

        containerStackView.addArrangedSubview(audioHalfModalView)
        updateModalPlayerView()
    }
    
    func getAlbumImage() {
        
        if let currentTrack = spotifyAudioPlayer.currentTrack {
            if let imageURL = currentTrack.largestAlbumCoverURL {
                ImageDataRequest.getAlbumCoverImage(imageUrl: imageURL, completion: { [weak self] (image)  in
                    if let strongSelf = self {
                        
                        guard let image = image else { return }
                        
                        strongSelf.audioHalfModalView.albumCoverImage = image
                        strongSelf.audioHalfModalView.audioButton.updateBackgroundImage(image: image)
                    }
                })
            }
        }
    }
    
    func updateModalPlayerView() {

        if let currentTrack = spotifyAudioPlayer.currentTrack {
            audioHalfModalView.artistLabel.text = currentTrack.albumArtistDisplay
            audioHalfModalView.songLabel.text = currentTrack.name
        }
        
        spotifyAudioPlayer.isPlaying ? audioHalfModalView.audioButton.setButtonPause() : audioHalfModalView.audioButton.setButtonPlay()
        getAlbumImage()
    }
}

// MARK: - HalfModalPresentable methods
extension AudioModalViewController: HalfModalPresentable {
    
    @IBAction func maximizeButtonTapped(_ sender: Any) {
        
        maximizeToFullScreen()
    }
    
    @IBAction func minimizeButtonTapped(_ sender: Any) {
        
        if let delegate = navigationController?.transitioningDelegate as? AudioHalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "audioModalDismissed"), object: nil)
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - AudioModalViewDelegate + SpotifyAudioControllable methods
extension AudioModalViewController: AudioModalViewDelegate, SpotifyAudioControllable {
    
    func handlePlayPreviousTrack() {
        spotifyAudioPlayer.playPreviousTrack()
    }
    
    func handlePlayNextTrack() {
        spotifyAudioPlayer.skipTrack()
    }

    func togglePlay() {
        
        if spotifyAudioPlayer.isPlaying {
            setAudioPause()
            audioHalfModalView.audioButton.setButtonPlay()
        } else {
            setAudioPlay()
            audioHalfModalView.audioButton.setButtonPause()
        }
    }
}
