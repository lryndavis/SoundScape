
import UIKit

class AudioModalViewController: UIViewController, HalfModalPresentable {
    
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    var albumCoverImage: UIImage?
    var audioHalfModalView: AudioHalfModalView?
    
    @IBOutlet weak var containerStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(AudioModalViewController.updateModalPlayerView), name: NSNotification.Name(rawValue: "trackChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getAlbumImage(isUpdatingView: false)
    }
    
    func setupView() {

        audioHalfModalView = AudioHalfModalView(albumCoverImage: self.albumCoverImage)
        guard let audioHalfModalView = audioHalfModalView else { return }
        audioHalfModalView.delegate = self
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)

        containerStackView.addArrangedSubview(audioHalfModalView)
        updateModalPlayerView()
    }
    
    func getAlbumImage(isUpdatingView: Bool) {
        
        if let currentTrack = spotifyAudioPlayer.currentTrack {
            if let imageURL = currentTrack.largestAlbumCoverURL {
                ImageDataRequest.getAlbumCoverImage(imageUrl: imageURL, completion: { [weak self] (image)  in
                    if let strongSelf = self {
                        
                        strongSelf.albumCoverImage = image
                        
                        if isUpdatingView {
                            guard let image = image,
                                  let audioModal = strongSelf.audioHalfModalView,
                                  let audioModalButton = audioModal.audioButton else { return }
                            audioModal.albumCoverImage = image
                            audioModalButton.backgroundImage? = image
                            audioModalButton.updateBackgroundImage()
                        } else {
                            strongSelf.setupView()
                        }
                    }
                })
            }
        }
    }
    
    func updateModalPlayerView() {
        
        guard let audioHalfModalView = audioHalfModalView else { return }
        if let currentTrack = spotifyAudioPlayer.currentTrack {
            audioHalfModalView.artistLabel.text = currentTrack.albumArtistDisplay
            audioHalfModalView.songLabel.text = currentTrack.name
        }
        
        getAlbumImage(isUpdatingView: true)
    }
    
    @IBAction func maximizeButtonTapped(_ sender: Any) {
        
         maximizeToFullScreen()
    }

    @IBAction func minimizeButtonTapped(_ sender: Any) {
        
        if let delegate = navigationController?.transitioningDelegate as? AudioHalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension AudioModalViewController: AudioModalViewDelegate {
    
    func handlePlayPreviousTrack() {
        spotifyAudioPlayer.playPreviousTrack()
    }
    
    func handlePlayNextTrack() {
        spotifyAudioPlayer.skipTrack()
    }
}
