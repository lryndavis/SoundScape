
import Foundation
import BoltsSwift


extension SpotifyApiTask {
    
    //GET /tracks
    static func readSpotifyTrack(trackId: String) -> Task<SpotifyTrack> {
        let request = ReadSpotifyTrackApiRequest(trackId: trackId)
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedObject(obj: $0) as SpotifyTrack
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
    static func readSpotifyUser(userId: String) -> Task<SpotifyUser> {
        let request = ReadSpotifyUserApiRequest(userId: userId)
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedObject(obj: $0) as SpotifyUser
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
    static func readSpotifyTracks(trackIds: [String]) -> Task<[SpotifyTrack]> {
        let request = ReadSpotifyTracksApiRequest(trackIds: trackIds)
        
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedArray(obj: $0, key: "tracks") as [SpotifyTrack]
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
    static func readSpotifyTrackSearch(query: String) -> Task<[SpotifyTrack]> {
        
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
    
    //GET current user /me
    static func readCurrentSpotifyUser() -> Task<CurrentSpotifyUser> {
        
        let request = ReadCurrentSpotifyUserRequest()
        return SpotifyApiTask.buildRequest(request) {
            try SpotifyApiTask.createUnboxedObject(obj: $0)
        }
    }
    
    class ReadCurrentSpotifyUserRequest: AuthenticatedApiRequest {
        
        override init() {
            super.init()
        }
        
        override var path: String {
            return SpotifyApiPath.currentUser.path()
        }
    }
    
    // convert track objects to extended tracks for use throughout app 
    static func getExtendedSpotifyTracks(nearbyTracks: [SoundScapeTrack]) -> Task<[SpotifyTrackExtended]> {
        
        let taskCompletionSource = TaskCompletionSource<[SpotifyTrackExtended]>()
        var nearbyExtendedSpotifyTracks = [SpotifyTrackExtended]()
        let dispatchGroup = DispatchGroup()
        
        for nearbyTrack in nearbyTracks {
            
            dispatchGroup.enter()
            
            SpotifyApiTask.readSpotifyTrack(trackId: nearbyTrack.spotifyId).continueOnSuccessWith { track in
                
                let newSpotifyTrackExtended = SpotifyTrackExtended(track: track, user: nil, soundScapeId: nearbyTrack.id, trackType: .soundScapeTrack)
                nearbyExtendedSpotifyTracks.insert(newSpotifyTrackExtended, at: 0)
                
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            
            taskCompletionSource.trySet(result: nearbyExtendedSpotifyTracks)
        }
        return taskCompletionSource.task
    }
       
}


