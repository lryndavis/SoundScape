
import UIKit

// base container view controller which handles the universal mini player to be present on all screens
// mini player is hidden until first track is played 
class BaseContainerViewController: UIViewController {

    @IBOutlet weak var audioPlayerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayerContainerView.isHidden = true

        if let spotifyAudioPlayerVC = childViewControllers[safe: 1] as? SpotifyAudioPlayerViewController {
                spotifyAudioPlayerVC.spotifyAudioPlayerDelegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseContainerViewController: UniversalAudioPlayerDelegate {
    
    func showAudioPlayer() {
        
        if audioPlayerContainerView.isHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.audioPlayerContainerView.isHidden = false
            }
        }
    }
}
