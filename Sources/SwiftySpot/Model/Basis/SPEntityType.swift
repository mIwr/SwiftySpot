//
//  SPEntityType.swift
//  SwiftySpot
//
//  Created by developer on 01.11.2023.
//

///Generalized Spotify spotify entity enum
public enum SPEntityType: UInt8 {
    case unknown = 0
    case artist = 1
    case album = 2
    case playlist = 3
    case track = 4
    
    case search = 100
}

extension SPEntityType {
    
    public static let entityPrefixDict: [SPEntityType: String] = [
        .artist: SPConstants.artistUriPrefix,
        .album: SPConstants.albumUriPrefix,
        .playlist: SPConstants.playlistUriPrefix,
        .track: SPConstants.trackUriPrefix,
        .search: SPConstants.searchUriPrefix,
    ]
    
    public static let inversedEntityPrefixDict: [String: SPEntityType] = [
        SPConstants.artistUriPrefix: .artist,
        SPConstants.albumUriPrefix: .album,
        SPConstants.playlistUriPrefix: .playlist,
        SPConstants.trackUriPrefix: .track,
        SPConstants.searchUriPrefix: .search,
    ]
    
    public static func examineUri(_ uri: String) -> (SPEntityType, String) {
        for entry in inversedEntityPrefixDict {
            let possibleId = uri.replacingOccurrences(of: entry.key, with: "")
            if (possibleId != uri) {
                return (entry.value, possibleId)
            }
        }
        return (SPEntityType.unknown, uri)
    }
    
    public var uriPrefix: String {
        get {
            if let safePrefix = SPEntityType.entityPrefixDict[self] {
                //O(1) prefix define
                return safePrefix
            }
            //O(n) prefix define for syntax complying
            switch (self) {
            case .unknown: return ""
            case .artist: return SPConstants.artistUriPrefix
            case .album: return SPConstants.albumUriPrefix
            case .playlist: return SPConstants.playlistUriPrefix
            case .track: return SPConstants.trackUriPrefix
            case .search: return SPConstants.searchUriPrefix
            }
        }
    }
}
