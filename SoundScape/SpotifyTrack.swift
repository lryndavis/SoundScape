
import Foundation
import Unbox

struct SpotifyAlbum: Unboxable {
    
    let albumType: String
    let artists: [SpotifyArtist]
    let availableMarkets: [String]
    let externalUrls: ExternalUrl
    let href: String
    let id: String
    let images: [SpotifyImage]
    let name: String
    let type: String
    let uri: String
    
    init(unboxer: Unboxer) throws {
        self.albumType              = try unboxer.unbox(key: "album_type")
        self.artists                = try unboxer.unbox(key: "artists")
        self.availableMarkets       = try unboxer.unbox(key: "available_markets")
        self.externalUrls           = try unboxer.unbox(key: "external_urls")
        self.href                   = try unboxer.unbox(key: "href")
        self.id                     = try unboxer.unbox(key: "id")
        self.images                 = try unboxer.unbox(key: "images")
        self.name                   = try unboxer.unbox(key: "name")
        self.type                   = try unboxer.unbox(key: "type")
        self.uri                    = try unboxer.unbox(key: "uri")
    }
}

struct SpotifyArtist: Unboxable {
    
    let externalUrls: ExternalUrl
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
    
    init(unboxer: Unboxer) throws {
        self.externalUrls           = try unboxer.unbox(key: "external_urls")
        self.href                   = try unboxer.unbox(key: "href")
        self.id                     = try unboxer.unbox(key: "id")
        self.name                   = try unboxer.unbox(key: "name")
        self.type                   = try unboxer.unbox(key: "type")
        self.uri                    = try unboxer.unbox(key: "uri")
    }
}

struct ExternalUrl: Unboxable {
    
    let spotifyUrl: String
    
    init(unboxer: Unboxer) throws {
        self.spotifyUrl             = try unboxer.unbox(key: "spotify")
    }
}

struct SpotifyImage: Unboxable {
    
    let height: Int?
    let url: String?
    let width: Int?
    
    init(unboxer: Unboxer) throws {
        self.height                 = unboxer.unbox(key: "height")
        self.url                    = unboxer.unbox(key: "url")
        self.width                  = unboxer.unbox(key: "width")
    }
}

struct ExternalId: Unboxable {
    
    let isrc: String
    
    init(unboxer: Unboxer) throws {
        self.isrc                   = try unboxer.unbox(key: "isrc")
    }
}

struct SpotifyTrack: Unboxable {
    
    let album: SpotifyAlbum
    let artists: [SpotifyArtist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalIds: ExternalId
    let externalUrls: ExternalUrl
    let href: String
    let id: String
    let name: String
    let popularity: Int
    let previewURL: String?
    let trackNumber: Int
    let type: String
    let uri: String
    
    init(unboxer: Unboxer) throws {
        
        self.album                  = try unboxer.unbox(key: "album")
        self.artists                = try unboxer.unbox(key: "artists")
        self.availableMarkets       = try unboxer.unbox(key: "available_markets")
        self.discNumber             = try unboxer.unbox(key: "disc_number")
        self.durationMs             = try unboxer.unbox(key: "duration_ms")
        self.explicit               = try unboxer.unbox(key: "explicit")
        self.externalIds            = try unboxer.unbox(key: "external_ids")
        self.externalUrls           = try unboxer.unbox(key: "external_urls")
        self.href                   = try unboxer.unbox(key: "href")
        self.id                     = try unboxer.unbox(key: "id")
        self.name                   = try unboxer.unbox(key: "name")
        self.popularity             = try unboxer.unbox(key: "popularity")
        self.previewURL             = unboxer.unbox(key: "preview_url")
        self.trackNumber            = try unboxer.unbox(key: "track_number")
        self.type                   = try unboxer.unbox(key: "type")
        self.uri                    = try unboxer.unbox(key: "uri")
    }
    
    //TODO fix force unwrap + move into spotify image 
    var largestImageUrl: String? {
        
        let images = self.album.images
        let largestImage = images.sorted{ $0.width! > $1.width! }
        
        return largestImage[safe: 0]?.url
    }
    
    var smallestImageUrl: String? {
        
        let images = self.album.images
        let smallestImage = images.sorted{ $0.width! < $1.width! }
        
        return smallestImage[safe: 0]?.url
    }
}
