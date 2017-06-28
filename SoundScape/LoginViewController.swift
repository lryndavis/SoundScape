
import UIKit

class LoginViewController: UIViewController {

    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var loginUrl: URL?
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    func updateAfterFirstLogin() {
        
        let userDefaults = UserDefaults.standard

        if let sessionObj:AnyObject = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey) as AnyObject? {

            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BaseContainerViewController")
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func onLoginButtonTap(_ sender: Any) {
        
        let spotifyAuthManager = SpotifyAuthManager()
        loginUrl = spotifyAuthManager.loginURL
        let auth = SPTAuth.defaultInstance()
        
        UIApplication.shared.open(loginUrl!, options: [ : ]) { (success) in
            
            if success {
                if (auth?.canHandle(auth?.redirectURL))! {
                    print("success: can handle redirect")
                } else {
                    print("error: cannot handle recirect")
                }
            } else {
                print("cannot open login url")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    





