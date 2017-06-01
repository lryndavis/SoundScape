
import UIKit

class ModalNavController: UINavigationController, HalfModalPresentable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return isHalfModalMaximized() ? .default : .lightContent
    }
}
