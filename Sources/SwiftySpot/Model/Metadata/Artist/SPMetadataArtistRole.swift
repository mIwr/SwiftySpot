//
//  SPArtistRole.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

///Artist role type
public enum SPMetadataArtistRole: Int32 {
    case UNKNOWN = 0
    case MAIN_ARTIST = 1
    case FEATURED_ARTIST = 2
    case REMIXER = 3
    case ACTOR = 4
    case COMPOSER = 5
    case CONDUCTOR = 6
    case ORCHESTRA = 7
}

extension SPMetadataArtistRole {
    static func from(protobuf: Spotify_Metadata_ArtistRole) -> SPMetadataArtistRole {
        switch (protobuf) {
        case .unknown: return .UNKNOWN
        case .mainArtist: return .MAIN_ARTIST
        case .featuredArtist: return .FEATURED_ARTIST
        case .remixer: return .REMIXER
        case .actor: return .ACTOR
        case .composer: return .COMPOSER
        case .conductor: return .CONDUCTOR
        case .orchestra: return .ORCHESTRA
        
        case .UNRECOGNIZED:
            #if DEBUG
            print("Unknown artist role " + String(protobuf.rawValue))
            #endif
            return .UNKNOWN
        }
    }
}
