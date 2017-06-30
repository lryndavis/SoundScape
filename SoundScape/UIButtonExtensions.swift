
import Foundation

extension UIButton {
    
    func setButtonPlay(animated: Bool = false) {
        
        let playImage = UIImage(named: "play.png")
        let tintedPlayImage = playImage?.withRenderingMode(.alwaysTemplate)
        
        if animated {
            self.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.setImage(tintedPlayImage, for: .normal)
                self.alpha = 1.0
            })
        } else {
            self.setImage(tintedPlayImage, for: .normal)
        }
    }
    
    func setButtonPause(animated: Bool = false) {
        
        let pauseImage = UIImage(named: "pause.png")
        let tintedPauseImage = pauseImage?.withRenderingMode(.alwaysTemplate)
        
        if animated {
            self.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.setImage(tintedPauseImage, for: .normal)
                self.alpha = 1.0
            })
        } else {
            self.setImage(tintedPauseImage, for: .normal)
        }
    }
}
