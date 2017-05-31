
import Foundation


class SpotifyAuthManager {
    
    private let redirectURL = "soundscape://returnAfterLogin/"
    private let clientId = "68e2248cfb344dfab559a940dd05f5f2"
    private let userDefaultsKey = "SpotifySession"
    let loginURL: URL!
    
    init() {
        
        let auth = SPTAuth.defaultInstance()
        
        auth?.clientID = self.clientId
        auth?.redirectURL = URL(string: self.redirectURL)
        auth?.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        auth?.sessionUserDefaultsKey = self.userDefaultsKey
        
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
                    print("Error: Session not renewed")
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



