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
    
    
    public static let searchDesktopPersistedQuery: (opName: String, persistedQueryHashHex: String) = (opName: "searchDesktop", persistedQueryHashHex: "2ae11a661a59c58695ad9b8bd6605dce6e3876f900555e21543c19f7a0a0ea6a")
    
    //Valid Apollo GraphQL persisted queries' SHA256 hashes can be retrieved from https://open.spotifycdn.com/cdn/build/web-player/xpui-routes-search.{xpui_route. Example - a88913ae}.js
    public var webOpType: (opName: String, persistedQueryHashHex: String) {
        get {
            switch self {
            case .album: return (opName: "searchAlbums", persistedQueryHashHex: "a71d2c993fc98e1c880093738a55a38b57e69cc4ce5a8c113e6c5920f9513ee2")
            case .artist: return (opName: "searchArtists", persistedQueryHashHex: "0e6f9020a66fe15b93b3bb5c7e6484d1d8cb3775963996eaede72bac4d97e909")
            case .genre: return (opName: "searchGenres", persistedQueryHashHex: "9e1c0e056c46239dd1956ea915b988913c87c04ce3dadccdb537774490266f46")
            case .playlist: return (opName: "searchPlaylists", persistedQueryHashHex: "fc3a690182167dbad20ac7a03f842b97be4e9737710600874cb903f30112ad58")
            case .userProfile: return (opName: "searchUsers", persistedQueryHashHex: "d3f7547835dc86a4fdf3997e0f79314e7580eaf4aaf2f4cb1e71e189c5dfcb1f")
            case .track: return (opName: "searchTracks", persistedQueryHashHex: "5307479c18ff24aa1bd70691fdb0e77734bede8cce3bd7d43b6ff7314f52a6b8")
            case .audioEpisode: return (opName: "searchFullEpisodes", persistedQueryHashHex: "37e3f18a893c9969817eb0aa46f4a69479a8b0f7964a36d801e69a8c0ab17fcb")
            case .show: return (opName: "searchFullEpisodes", persistedQueryHashHex: "37e3f18a893c9969817eb0aa46f4a69479a8b0f7964a36d801e69a8c0ab17fcb")
            }
        }
    }
}
