
import UIKit

class LoginViewController: UIViewController {

    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var loginUrl: URL?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    func updateAfterFirstLogin() {
        
        let userDefaults = UserDefaults.standard

        if let sessionObj: AnyObject = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey) as AnyObject? {

            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            
            SpotifyManager.getCurrentUser(session: session, completion: { (user) in
                let userRef = FirebaseService.baseRef.child(FirebaseService.ChildRef.songUser.rawValue)
                userRef.child(user.canonicalUserName).setValue(SpotifyUser.toAnyObject(trackKey: nil, user: user))
            })
        }
    }
    
    //initial login and handle redirect from spotify 
    @IBAction func onLoginButtonTap(_ sender: Any) {
        
        let spotifyAuthManager = SpotifyAuthManager()
        loginUrl = spotifyAuthManager.loginURL
        let auth = SPTAuth.defaultInstance()
        
        UIApplication.shared.open(loginUrl!, options: [ : ]) { (success) in
            
            if success {
                if (auth?.canHandle(auth?.redirectURL))! {
                    self.loginButton.isHidden = true 
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
    





