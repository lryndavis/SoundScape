
import UIKit

class AudioPausePlayButton: UIButton {

    init() {
        super.init(frame: CGRect.zero)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func buildView() {
        
        self.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
        self.tintColor = .white
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func setButtonPlay() {
        
        let playImage = UIImage(named: "play.png")
        let tintedPlayImage = playImage?.withRenderingMode(.alwaysTemplate)
        
        self.setImage(tintedPlayImage, for: .normal)
    }
    
    func setButtonPause() {
        
        let pauseImage = UIImage(named: "pause.png")
        let tintedPauseImage = pauseImage?.withRenderingMode(.alwaysTemplate)
        
        self.setImage(tintedPauseImage, for: .normal)
    }
}
