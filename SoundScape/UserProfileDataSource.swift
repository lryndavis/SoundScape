
import Foundation

class UserProfileDataSource: SpotifyDataSource {
    
    var sptUser: SPTUser?
    
    func loadData(username: String, completion: @escaping (Bool) -> ()) {
        
        getSPTUserByUsername(username: username, completion: {
            user in
            self.sptUser = user
            completion(true)
        })
    }
    
}
