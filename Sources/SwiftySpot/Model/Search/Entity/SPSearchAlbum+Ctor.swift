//
//  SPSearchAlbum.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

import SwiftProtobuf

extension SPSearchAlbum {
    
    public init(artistNames: [String], type: Int, releaseYear: UInt, state: Int, timestamp: Int64, userCountryReleaseIsoTime: String) {
        self.artistNames = artistNames
        self.type = Int32(clamping: type)
        self.releaseYear = Int32(clamping: releaseYear)
        self.state = Int32(clamping: state)
        self.timestamp = Google_Protobuf_Timestamp(seconds: timestamp)
        self.userCountryReleaseIsoTime = userCountryReleaseIsoTime
    }
    
    public func asMetaObj(uri: String, name: String) -> SPMetadataAlbum {
        let meta = SPMetadataAlbum(gid: [], name: name, uri: uri, artists: artistNames.map({ name in
            return SPMetadataArtist(gid: [], name: name)
        }))
        return meta
    }
}
