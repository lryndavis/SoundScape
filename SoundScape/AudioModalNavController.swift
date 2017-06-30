
import UIKit

class AudioModalNavController: UINavigationController, HalfModalPresentable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return isHalfModalMaximized() ? .default : .lightContent
    }
}
