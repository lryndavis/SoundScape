
import Foundation


class SpotifyAuthManager {

    static let kRedirectURL = "soundscape://returnAfterLogin/"
    static let kUserDefaultsKey = "SpotifySession"
    static let kClientId = "68e2248cfb344dfab559a940dd05f5f2"
    static let kSwapURL = "http://localhost:1234/swap"
    static let kRefreshURL = "http://localhost:1234/refresh"
    
    let loginURL: URL!
    
    init() {
        let auth = SPTAuth.defaultInstance()!
        
        auth.clientID = SpotifyAuthManager.kClientId
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        auth.sessionUserDefaultsKey = SpotifyAuthManager.kUserDefaultsKey
        auth.redirectURL = URL(string: SpotifyAuthManager.kRedirectURL)
        auth.tokenSwapURL = URL(string: SpotifyAuthManager.kSwapURL)
        auth.tokenRefreshURL = URL(string: SpotifyAuthManager.kRefreshURL)
        
        self.loginURL = auth.spotifyWebAuthenticationURL()
    }
    
     func refreshSession(isSessionValid: @escaping (Bool) -> Void) {
        
        guard let session = SPTAuth.defaultInstance().session else {
            isSessionValid(false)
            return
        }
        if session.isValid() {
            isSessionValid(true)
        } else {
            SPTAuth.defaultInstance().renewSession(session, callback: { (error, sessionData) in
                
                guard let _ = sessionData, error == nil else {
                    print("\(String(describing: error)): session not renewed")
                    isSessionValid(false)
                    return
                }
                SPTAuth.defaultInstance().session = session
                isSessionValid(true)
            })
        }
    }
    
}



