
import UIKit

class FavoriteSongButton: UIButton {
    
    init() {
        super.init(frame: CGRect.zero)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func buildView() {
        
        self.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.imageView?.contentMode = .scaleAspectFit
    }
}

extension FavoriteSongButton {
    
    func setButtontoFavorite(animated: Bool = false) {
        
        let favoriteImage = UIImage(named: "favorite-solid.png")
        
        if animated {
            self.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.setImage(favoriteImage, for: .normal)
                self.alpha = 1.0
            })
        } else {
            self.setImage(favoriteImage, for: .normal)
        }
    }
    
    func setButtonToUnfavorite(animated: Bool = false) {
        
        let unfavoriteImage = UIImage(named: "favorite-line.png")
        
        if animated {
            self.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.setImage(unfavoriteImage, for: .normal)
                self.alpha = 1.0
            })
        } else {
            self.setImage(unfavoriteImage, for: .normal)
        }
    }
}
