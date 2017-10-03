
import Foundation
import Firebase
import Unbox

// simplified user object for persisting user info in firebase
struct SoundScapeUser {
    
    let canonicalUserName: String
    let uri: String
    var firebaseRef: DatabaseReference?
    var id: String?
    private(set) var favoritedSongs: [String]?
    
    init(canonicalUserName: String, uri: String) {
        self.canonicalUserName      = canonicalUserName
        self.uri                    = uri
        self.favoritedSongs         = nil
    }
    
    init?(snapshot: DataSnapshot) {
        
        if let snapshotValue = snapshot.value as? [String: AnyObject],
            let canonicalUserName = snapshotValue["canonicalUserName"] as? String,
            let uri = snapshotValue["uri"] as? String {
                self.canonicalUserName  = canonicalUserName
                self.uri                = uri
                self.id                 = snapshotValue["id"] as? String
                self.favoritedSongs     = FirebaseService.stringsArrayWithTrueKeys(snapshotValue: snapshotValue[FirebaseService.FirebaseUserKeys.favoritedSongs.rawValue])
                self.firebaseRef        = snapshot.ref
            } else {
                return nil
        }
    }
    
    func toDictionary(id: String) -> [String: Any] {
        
        return [
            "canonicalUserName": self.canonicalUserName,
            "uri": self.uri,
            "id": id
        ]
    }
    
    func removeFromFirebase() {
        self.firebaseRef?.removeValue()
    }
    
    mutating func createUserInFirebase() {
        
        let reference = Database.database().reference(withPath: FirebaseService.FirebasePaths.users.rawValue)
        
        self.firebaseRef = reference.childByAutoId()
        let id = self.firebaseRef?.key
        self.firebaseRef?.setValue(self.toDictionary(id: id!))
    }
    
    mutating func addFavoriteSong(songId: String) {
        
        if let path = self.favoriteSongPath(songId: songId) {
            let reference = Database.database().reference(withPath: path)
            reference.setValue(true)
            
            if let _ = self.favoritedSongs {
                self.favoritedSongs?.append(songId)
            } else {
                var newFavoriteSongs = [String]()
                newFavoriteSongs.append(songId)
                self.favoritedSongs = newFavoriteSongs
            }
        }
    }

    mutating func removeFavoriteSong(songId: String) {
        
        if let path = self.favoriteSongPath(songId: songId) {
            let reference = Database.database().reference(withPath: path)
            reference.removeValue()
            
            let newFavorites = self.favoritedSongs?.filter{ $0 !=  songId }
            self.favoritedSongs = newFavorites
        }
    }
    
    func favoriteSongPath(songId: String) -> String? {
        
        if let id = self.id {
            
            return [FirebaseService.FirebasePaths.users.rawValue,
                    id,
                    FirebaseService.FirebaseUserKeys.favoritedSongs.rawValue,
                    songId].joined(separator: FirebaseService.FirebasePathSeparator)
        }
        return nil
    }

}



