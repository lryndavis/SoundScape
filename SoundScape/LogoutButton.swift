
import UIKit

class LogoutButton: UIButton {

    init() {
        super.init(frame: CGRect.zero)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func buildView() {
        
        self.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        self.imageView?.contentMode = .scaleAspectFit
        
        let logoutImage = UIImage(named: "settings.png")
        self.setImage(logoutImage, for: .normal)
    }

}
