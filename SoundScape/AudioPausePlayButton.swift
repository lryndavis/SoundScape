
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
}
