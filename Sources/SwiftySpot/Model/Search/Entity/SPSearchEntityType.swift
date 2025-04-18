//
//  SPSearchEntityType.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

public enum SPSearchEntityType: UInt8 {
    case artist = 1
    case album = 2
    case genre = 3
    case playlist = 4
    case show = 5
    case track = 6
    case audioEpisode = 7
    case userProfile = 8
    //entity_types=album,artist,genre,playlist,user_profile,track,audio_episode,show -> 02|01|03|04|08|06|07|05
}

extension SPSearchEntityType {
    public var apiKey: String {
        get {
            switch self {
            case .album: return "album"
            case .artist: return "artist"
            case .genre: return "genre"
            case .playlist: return "playlist"
            case .userProfile: return "user_profile"
            case .track: return "track"
            case .audioEpisode: return "audio_episode"
            case .show: return "show"
            }
        }
    }
    
    
    public static let searchDesktopPersistedQuery: (opName: String, persistedQueryHashHex: String) = (opName: "searchDesktop", persistedQueryHashHex: "d9f785900f0710b31c07818d617f4f7600c1e21217e80f5b043d1e78d74e6026")
    
    //Valid Apollo GraphQL persisted queries' SHA256 hashes can be retrieved from https://open.spotifycdn.com/cdn/build/web-player/xpui-routes-search.{xpui_route. Example - a88913ae}.js
    public var webOpType: (opName: String, persistedQueryHashHex: String) {
        get {
            switch self {
            case .album: return (opName: "searchAlbums", persistedQueryHashHex: "a71d2c993fc98e1c880093738a55a38b57e69cc4ce5a8c113e6c5920f9513ee2")
            case .artist: return (opName: "searchArtists", persistedQueryHashHex: "0e6f9020a66fe15b93b3bb5c7e6484d1d8cb3775963996eaede72bac4d97e909")
            case .genre: return (opName: "searchGenres", persistedQueryHashHex: "9e1c0e056c46239dd1956ea915b988913c87c04ce3dadccdb537774490266f46")
            case .playlist: return (opName: "searchPlaylists", persistedQueryHashHex: "fc3a690182167dbad20ac7a03f842b97be4e9737710600874cb903f30112ad58")
            case .userProfile: return (opName: "searchUsers", persistedQueryHashHex: "d3f7547835dc86a4fdf3997e0f79314e7580eaf4aaf2f4cb1e71e189c5dfcb1f")
            case .track: return (opName: "searchTracks", persistedQueryHashHex: "bc1ca2fcd0ba1013a0fc88e6cc4f190af501851e3dafd3e1ef85840297694428")
            case .audioEpisode: return (opName: "searchFullEpisodes", persistedQueryHashHex: "308e2a1f392c0f1ea9aa921393de470424bef0d0ea417b086ae3e9d960e327de")
            case .show: return (opName: "searchFullEpisodes", persistedQueryHashHex: "308e2a1f392c0f1ea9aa921393de470424bef0d0ea417b086ae3e9d960e327de")
            }
        }
    }
}
