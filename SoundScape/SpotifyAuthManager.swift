
import Foundation


class SpotifyAuthManager {

    static let kRedirectURL = "soundscape://returnAfterLogin/"
    static let kUserDefaultsKey = "SpotifySession"
    static let kClientId = "68e2248cfb344dfab559a940dd05f5f2"
    
    let loginURL: URL!
    
    init() {
        
        let auth = SPTAuth.defaultInstance()
        
        auth?.clientID = SpotifyAuthManager.kClientId
        auth?.redirectURL = URL(string: SpotifyAuthManager.kRedirectURL)
        auth?.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        auth?.sessionUserDefaultsKey = SpotifyAuthManager.kUserDefaultsKey
        
        self.loginURL = auth?.spotifyWebAuthenticationURL()
    }
    
     func refreshSession(segueToInitialView: @escaping (Bool) -> Void) {
        
        guard let session = SPTAuth.defaultInstance().session else {
            segueToInitialView(false)
            return
        }
        if session.isValid() {
            segueToInitialView(true)
        } else {
            SPTAuth.defaultInstance().renewSession(session, callback: { (error, sessionData) in
                guard let _ = sessionData, error == nil else {
                    print("error: session not renewed")
                    segueToInitialView(false)
                    return
                }
                segueToInitialView(true)
            })
        }
    }
    
    static func endSession() {
        
        let auth = SPTAuth.defaultInstance()
        auth?.session = nil
    }
}



