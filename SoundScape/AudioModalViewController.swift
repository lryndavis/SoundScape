
import UIKit

class AudioModalViewController: UIViewController {
    
    let spotifyManager = SpotifyManager.sharedInstance
    var audioHalfModalView = AudioHalfModalView()
    
    @IBOutlet weak var containerStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
    
        setupView()
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getAlbumImage()
        getTrackFavoriteStatus()
    }
    
    func setupView() {

        audioHalfModalView.delegate = self
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)

        containerStackView.addArrangedSubview(audioHalfModalView)
        
        updateModalPlayerView()
    }
    
    func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AudioModalViewController.updateModalPlayerView), name: NSNotification.Name(rawValue: "trackChanged"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didChangePositionNotification"), object: nil, queue: OperationQueue.main) {  [weak self] (notification) in
            if let strongSelf = self {
                guard let position = notification.userInfo?["position"] as? TimeInterval else { return }
                strongSelf.audioHalfModalView.updateProgressSlider(position: position)
            }
        }
    }
    
    func getAlbumImage() {
        
        if let currentTrack = spotifyManager.currentTrack {
            if let imageURL = currentTrack.albumCoverImageURLLarge {
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
    
    func getTrackFavoriteStatus() {
        
        if let currentTrack = spotifyManager.currentTrack,
            let currentUser = spotifyManager.currentUser {
            if currentTrack.isFavoritedByUser(user: currentUser) {
                audioHalfModalView.favoriteButton.setButtontoFavorite()
            } else {
                audioHalfModalView.favoriteButton.setButtonToUnfavorite()
            }
        }
    }
    
    func updateModalPlayerView() {

        if let currentTrack = spotifyManager.currentTrack {
            audioHalfModalView.artistLabel.text = currentTrack.albumArtistDisplayStr
            audioHalfModalView.songLabel.text = currentTrack.track.name
        }
        
        spotifyManager.isPlaying ? audioHalfModalView.audioButton.setButtonPause() : audioHalfModalView.audioButton.setButtonPlay()
        getAlbumImage()
    }
}

// MARK: - HalfModalPresentable methods
extension AudioModalViewController: HalfModalPresentable {
    
    @IBAction func maximizeButtonTapped(_ sender: Any) {
        
        maximizeToFullScreen()
        
        //spacerView.isHidden = false
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
        spotifyManager.playPreviousTrack()
    }
    
    func handlePlayNextTrack() {
        spotifyManager.skipTrack()
    }

    func togglePlay() {
        
        if spotifyManager.isPlaying {
            setAudioPause()
            audioHalfModalView.audioButton.setButtonPlay()
        } else {
            setAudioPlay()
            audioHalfModalView.audioButton.setButtonPause()
        }
    }
    
    func toggleFavoriteSong() {
        
        if let _ = spotifyManager.currentUser,
            let currentTrack = spotifyManager.currentTrack,
            let id = currentTrack.soundScapeId {
            
                if currentTrack.isFavoritedByUser(user: spotifyManager.currentUser!) {
                    spotifyManager.currentUser?.removeFavoriteSong(songId: id)
                    audioHalfModalView.favoriteButton.setButtonToUnfavorite(animated: true)
                } else {
                    spotifyManager.currentUser?.addFavoriteSong(songId: id)
                    audioHalfModalView.favoriteButton.setButtontoFavorite(animated: true)
            }
        }
    }
    
}
