
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
            
            self.audioPlayerContainerView.alpha = 0
            
            UIView.animate(withDuration: 0.2) {
                self.audioPlayerContainerView.alpha = 1
                self.audioPlayerContainerView.isHidden = false
            }
        }
    }
}
