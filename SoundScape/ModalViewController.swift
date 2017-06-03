
import UIKit

class ModalViewController: UIViewController, HalfModalPresentable {
    
    override func viewDidLoad() {
        
        print("calling view did load")
    }
    
    @IBAction func maximizeButtonTapped(_ sender: Any) {
        
         maximizeToFullScreen()
    }

    @IBAction func minimizeButtonTapped(_ sender: Any) {
        
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }

}
