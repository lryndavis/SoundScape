
import Foundation
import Firebase


class Song {
    
    let title: String
    let id: String
    
    init(title: String, id: String) {
        self.id = id
        self.title = title
    }
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]

        title = snapshotValue["title"] as! String
        id = snapshot.key
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "id": id
        ]
    }
}
