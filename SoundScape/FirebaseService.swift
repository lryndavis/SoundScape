
import Foundation
import Firebase
import FirebaseDatabase


class FirebaseService {

    static let baseRef = Database.database().reference()
    
    static let FirebasePathSeparator = "/"
    static let FirebaseEmptyValue = "null"
    
    enum FirebasePaths: String {
        case songs              = "songs"
        case songLocations      = "song_locations"
        case users              = "users"
    }
    
    enum FirebaseUserKeys: String {
        case favoritedSongs     = "favoritedSongs"
    }
    
    static func createFirebaseRef(pathComponents: [Any]?) -> DatabaseReference? {
        
        if let path = FirebaseService.createFirebasePath(pathComponents: pathComponents) {
            return Database.database().reference(withPath: path)
        }
        return nil
    }
    
    static func createFirebasePath(pathComponents: [Any]?) -> String? {
        
        guard let components = pathComponents else { return nil }
        
        var pathStrings = [String]()
        
        for component in components {
            if let componentString = component as? String {
                pathStrings.append(componentString)
            }
            
            if let path = component as? FirebasePaths {
                pathStrings.append(path.rawValue)
            }
        }
        
        if !pathStrings.isEmpty {
            return pathStrings.joined(separator: FirebaseService.FirebasePathSeparator)
        }
        return nil 
    }
    
    static func stringsArrayWithTrueKeys(snapshotValue: Any?) -> [String]? {
        var result: [String]? = nil
        
        if let dict = snapshotValue as? [String: Bool] {
            
            var keys = [String]()
            for (key, value) in dict {
                if value == true {
                    keys.append(key)
                }
            }
            
            if keys.count > 0 {
                result = keys
            } else {
                result = nil
            }
        }
        return result
    }
 }

