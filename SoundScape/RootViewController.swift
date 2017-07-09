
import UIKit

class RootViewController: UIViewController {

    lazy private var loginVC: LoginViewController! = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }()
    
    lazy private var baseContainerVC: BaseContainerViewController! = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BaseContainerViewController") as! BaseContainerViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.updateAfterSuccessfulLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let authManager = SpotifyAuthManager()

        authManager.refreshSession { [weak self] (success) in
            if let strongSelf = self {
                if success {
                    strongSelf.addChildVC(viewController: strongSelf.baseContainerVC)
                } else {
                    strongSelf.addChildVC(viewController: strongSelf.loginVC)
                }
            }
        }
    }
    
    func updateAfterSuccessfulLogin() {
        
        removeChildVC(viewController: loginVC)
        addChildVC(viewController: baseContainerVC)
    }
    
    private func addChildVC(viewController: UIViewController) {

        addChildViewController(viewController)
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParentViewController: self)
    }
    
    private func removeChildVC(viewController: UIViewController) {

        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

