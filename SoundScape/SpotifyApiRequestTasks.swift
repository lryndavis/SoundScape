
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
    
    //GET tracks?ids={ids}
    static func readSpotifyTracks(trackIds: [String]) -> Task<[TempSpotifyTrack]> {
        let request = ReadSpotifyTracksApiRequest(trackIds: trackIds)
        
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedArray(obj: $0, key: "tracks") as [TempSpotifyTrack]
        }
    }
    
    class ReadSpotifyTracksApiRequest: AuthenticatedApiRequest {
        let trackIds: [String]
        var apiParams: [String: Any]
        
        init(trackIds: [String]) {
            self.trackIds = trackIds
            apiParams = ["ids": trackIds]
            super.init()
        }
        
        override var params: ApiParams {
            apiParams.merge(["ids": trackIds])
            return apiParams
        }
        
        override var path: String {
            return SpotifyApiPath.tracks.path()
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
}
