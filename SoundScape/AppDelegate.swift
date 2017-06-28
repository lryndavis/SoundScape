
import UIKit
import FirebaseDatabase
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var auth = SPTAuth()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authManager = SpotifyAuthManager()
        
        authManager.refreshSession { (success) in
            if success {
                // if spotify user is logged in or token is successfully refreshed, bypass login
                let baseVC = storyboard.instantiateViewController(withIdentifier: "BaseContainerViewController")
                self.window?.rootViewController = baseVC
                self.window?.makeKeyAndVisible()
                
            } else {
                // if no token, show login VC
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                self.window?.rootViewController = loginVC
                self.window?.makeKeyAndVisible()
            }
        }
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let auth = SPTAuth.defaultInstance()
        if (auth?.canHandle(url as URL!))! {
            
            auth?.handleAuthCallback(withTriggeredAuthURL: url as URL!) { (error, session) -> Void in
                
                if error != nil {
                    print("Auth error: \(String(describing: error))")
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessful"), object: nil)
            }
            
            return true
        }
        return false
    }
    
}

