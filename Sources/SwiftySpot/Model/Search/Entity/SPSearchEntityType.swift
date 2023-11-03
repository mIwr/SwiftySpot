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
}
