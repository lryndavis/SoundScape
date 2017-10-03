
import Foundation
import Unbox

struct CurrentSpotifyUser: Unboxable {
    
    let birthDate: String?
    let country: String?
    let displayName: String?
    let email: String?
    let externalUrl: ExternalUrl
    let followers: SpotifyFollower
    let href: String
    let id: String
    let images: [SpotifyImage]?
    let product: String?
    let type: String
    let uri: String
    
    init(unboxer: Unboxer) throws {
        self.birthDate          = unboxer.unbox(key: "birthdate")
        self.country            = unboxer.unbox(key: "country")
        self.displayName        = unboxer.unbox(key: "display_name")
        self.email              = unboxer.unbox(key: "email")
        self.externalUrl        = try unboxer.unbox(key: "external_urls")
        self.followers          = try unboxer.unbox(key: "followers")
        self.href               = try unboxer.unbox(key: "href")
        self.id                 = try unboxer.unbox(key: "id")
        self.images             = unboxer.unbox(key: "images")
        self.product            = unboxer.unbox(key: "product")
        self.type               = try unboxer.unbox(key: "type")
        self.uri                = try unboxer.unbox(key: "uri")
        
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
