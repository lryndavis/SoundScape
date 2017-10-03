
import Foundation
import Unbox

struct SpotifyUser: Unboxable {
    
    let displayName: String?
    let externalUrl: ExternalUrl
    let followers: [SpotifyFollower]?
    let href: String
    let id: String
    let images: [SpotifyImage]?
    let type: String
    let uri: String
    
    init(unboxer: Unboxer) throws {
        self.displayName            = unboxer.unbox(key: "display_name")
        self.externalUrl            = try unboxer.unbox(key: "external_urls")
        self.followers              = unboxer.unbox(key: "followers")
        self.href                   = try unboxer.unbox(key: "href")
        self.id                     = try unboxer.unbox(key: "id")
        self.images                 = unboxer.unbox(key: "images")
        self.type                   = try unboxer.unbox(key: "type")
        self.uri                    = try unboxer.unbox(key: "uri")
    }
    
    //TODO fix force unwrap + move this into spotifyimage class 
    var largestImageUrl: String? {
        
        guard let images = self.images else { return nil }
        let largestImage = images.sorted{ $0.width! > $1.width! }
        
        return largestImage[safe: 0]?.url
    }
    
    var smallestImageUrl: String? {
        
        guard let images = self.images else { return nil }
        let smallestImage = images.sorted{ $0.width! < $1.width! }
        
        return smallestImage[safe: 0]?.url
    }
}

struct SpotifyFollower: Unboxable {
    
    let href: String?
    let total: Int
    
    init(unboxer: Unboxer) throws {
        self.href                   = unboxer.unbox(key: "href")
        self.total                  = try unboxer.unbox(key: "total")
    }
}
