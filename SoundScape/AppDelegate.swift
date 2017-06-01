//
//  AppDelegate.swift
//  SoundScape
//
//  Created by Lauryn Davis on 5/24/17.
//  Copyright © 2017 Lauryn Davis. All rights reserved.
//

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
        
        auth.redirectURL     = URL(string: SpotifyAuthManager.kRedirectURL)
        //auth.sessionUserDefaultsKey = "current session"
        
        return true
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if auth.canHandle(auth.redirectURL) {
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
                
                if error != nil {
                    print("error: cannot handle redirect")
                }
                
                let userDefaults = UserDefaults.standard
                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session as Any)
                userDefaults.set(sessionData, forKey: SpotifyAuthManager.kUserDefaultsKey)
                userDefaults.synchronize()
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessful"), object: nil)
            })
            return true
        }
        return false
    }
    
}

