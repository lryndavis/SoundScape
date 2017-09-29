
import Foundation
import BoltsSwift


extension SpotifyApiTask {
    
    //GET /tracks
    static func readSpotifyTrack(trackId: String) -> Task<TempSpotifyTrack> {
        let request = ReadSpotifyTrackApiRequest(trackId: trackId)
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedObject(obj: $0) as TempSpotifyTrack
        }
    }
    
    class ReadSpotifyTrackApiRequest: AuthenticatedApiRequest {
        let trackId: String
        
        init(trackId: String) {
            self.trackId = trackId
            super.init()
        }
        
        override var path: String {
            return SpotifyApiPath.track(trackId).path()
            
        }
    }
    
    //GET /user
    static func readSpotifyUser(userId: String) -> Task<TempSpotifyUser> {
        let request = ReadSpotifyUserApiRequest(userId: userId)
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedObject(obj: $0) as TempSpotifyUser
        }
    }

    class ReadSpotifyUserApiRequest: AuthenticatedApiRequest {
        let userId: String
        
        init(userId: String) {
            self.userId = userId
            super.init()
        }
        
        override var path: String {
            return SpotifyApiPath.user(userId).path()
        }
    }
    
    //GET tracks?ids={ids}
    static func readSpotifyTracks(trackIds: [String]) -> Task<[TempSpotifyTrack]> {
        let request = ReadSpotifyTracksApiRequest(trackIds: trackIds)
        
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedArray(obj: $0, key: "tracks") as [TempSpotifyTrack]
        }
    }
    
    class ReadSpotifyTracksApiRequest: AuthenticatedApiRequest {
        let trackIds: [String]
        
        init(trackIds: [String]) {
            self.trackIds = trackIds
            super.init()
        }
        
        override var params: ApiParams {
            return [ "ids": trackIds ]
        }
        
        override var path: String {
            return SpotifyApiPath.tracks.path()
        }
    }
    
    //GET /search &type=tracks
    static func readSpotifyTrackSearch(query: String) -> Task<[TempSpotifyTrack]> {
        
        let request = ReadSpotifyTrackSearchRequest(query: query)
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedArray(obj: $0, key: "tracks.items", isNestedAtKeyPath: true)
        }
    }
    
    class ReadSpotifyTrackSearchRequest: AuthenticatedApiRequest {
        let query: String
        
        init(query: String) {
            self.query = query
            super.init()
        }
        
        override var path: String {
            return SpotifyApiPath.search.path()
        }
        
        override var params: ApiParams {
            return [ "q": query,
                     "type": "track"
            ]
        }
    }
    
}


