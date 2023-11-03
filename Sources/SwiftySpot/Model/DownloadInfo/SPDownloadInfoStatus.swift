//
//  SPDownloadInfoStatus.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Audio file source
public enum SPDownloadInfoStatus: Int8 {
  ///Remote
  case CDN = 0
  ///Cached
  case STORAGE = 1
  case RESTRICTED = 3
}

extension SPDownloadInfoStatus {
    static func from(protobuf: Spotify_Playplay_Proto_DownloadInfoStatus) -> SPDownloadInfoStatus {
        switch (protobuf) {
        case .cdn: return .CDN
        case .storage: return .STORAGE
        case .restricted: return .RESTRICTED
            
        case .UNRECOGNIZED:
            #if DEBUG
            print("Unknown download info type " + String(protobuf.rawValue))
            #endif
            return .RESTRICTED
        }
    }
}
