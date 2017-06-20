
import UIKit


class LoginViewController: UIViewController {

    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var loginUrl: URL?

    let loginToSongsView = "LoginToSongView"
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)

        loginButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let authManager = SpotifyAuthManager()
        authManager.refreshSession { (success) in
            if success {
                self.performSegue(withIdentifier: self.loginToSongsView, sender: nil)
            } else {
                self.loginButton.isHidden = false
                print("user not logged in")
            }
        }
    }
    
    func updateAfterFirstLogin() {

        loginButton.isHidden = true
        let userDefaults = UserDefaults.standard

        if let sessionObj:AnyObject = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey) as AnyObject? {

            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession

            self.session = firstTimeSession

            self.loginButton.isHidden = true
            self.performSegue(withIdentifier: self.loginToSongsView, sender: nil)
        }
    }
    
    //TODO: fix deprecation
    @IBAction func onLoginButtonTap(_ sender: Any) {
        
        let spotifyAuthManager = SpotifyAuthManager()
        loginUrl = spotifyAuthManager.loginURL
        let auth = SPTAuth.defaultInstance()
        
        if UIApplication.shared.openURL(loginUrl!) {
            
            if (auth?.canHandle(auth?.redirectURL))! {
                // To do - build in error handling
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    





