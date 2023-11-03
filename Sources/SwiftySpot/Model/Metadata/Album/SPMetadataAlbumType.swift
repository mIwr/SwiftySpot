//
//  SPMetadataAlbumType.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

import Foundation

public enum SPMetadataAlbumType: Int32 {
    case UNKNOWN = 0
    case ALBUM = 1
    case SINGLE = 2
    case COMPILATION = 3
    case EP = 4
    case AUDIOBOOK = 5
    case PODCAST = 6
}

extension SPMetadataAlbumType {
    static func from(protobuf: Spotify_Metadata_AlbumType) -> SPMetadataAlbumType {
        switch (protobuf) {
        case .unknown: return .UNKNOWN
        case .album: return .ALBUM
        case .single: return .SINGLE
        case .compilation: return .COMPILATION
        case .ep: return .EP
        case .audiobook: return .AUDIOBOOK
        case .podcast: return .PODCAST
        
        case .UNRECOGNIZED:
            #if DEBUG
            print("Unknown artist role " + String(protobuf.rawValue))
            #endif
            return .UNKNOWN
        }
    }
}
