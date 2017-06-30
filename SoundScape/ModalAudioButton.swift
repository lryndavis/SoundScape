
import UIKit


class ModalAudioButton: UIButton {
    
    var backgroundImage: UIImage?
    
    init(backgroundImage: UIImage) {
        super.init(frame: CGRect.zero)
        
        self.backgroundImage = backgroundImage
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func buildView() {

        self.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        self.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        
        updateBackgroundImage()
        
        self.tintColor = .white
        let playImage = UIImage(named: "play.png")
        let tintedPlayImage = playImage?.withRenderingMode(.alwaysTemplate)
        
        self.setImage(tintedPlayImage, for: .normal)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 60
        self.adjustsImageWhenHighlighted = false 
    }
    
    func updateBackgroundImage() {
        
        if let backgroundImage = backgroundImage {
            self.setBackgroundImage(backgroundImage, for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
        }
    }
    
}



