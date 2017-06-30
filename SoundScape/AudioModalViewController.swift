
import UIKit

class AudioModalViewController: UIViewController, HalfModalPresentable {
    
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    var albumCoverImage: UIImage?
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let currentTrack = spotifyAudioPlayer.currentTrack {
            if let imageURL = currentTrack.largestAlbumCoverURL {
                ImageDataRequest.getAlbumCoverImage(imageUrl: imageURL, completion: { [weak self] (image)  in
                    if let strongSelf = self {
                        strongSelf.albumCoverImage = image
                        strongSelf.setupView()
                    }
                })
            }
        }
    }
    
    func setupView() {

       let audioHalfModalView = AudioHalfModalView(albumCoverImage: self.albumCoverImage)
        
       containerStackView.translatesAutoresizingMaskIntoConstraints = false
       containerStackView.isLayoutMarginsRelativeArrangement = true
       containerStackView.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)

       containerStackView.addArrangedSubview(audioHalfModalView)
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
