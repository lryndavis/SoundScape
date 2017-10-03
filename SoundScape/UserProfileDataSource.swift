
import Foundation
import BoltsSwift

class UserProfileDataSource {
    
    var currentUser: CurrentSpotifyUser?
    
    func loadData(completion: @escaping (Bool) -> ()) {
        
        SpotifyApiTask.readCurrentSpotifyUser().continueOnSuccessWith { currentUser in
            
            self.currentUser = currentUser
            completion(true)
        } 
    }
    
}
