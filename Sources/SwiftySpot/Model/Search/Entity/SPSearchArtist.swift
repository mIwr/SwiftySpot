//
//  SPSearchArtist.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Artist search match
public class SPSearchArtist {
    ///Artist is verified flag
    public let verified: Bool
    
    public init(verified: Bool) {
        self.verified = verified
    }
    
    public func asMetaObj(uri: String, name: String) -> SPMetadataArtist {
        return SPMetadataArtist(gid: [], name: name, uri: uri)
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_Artist) -> SPSearchArtist {
        return SPSearchArtist(verified: protobuf.verified)
    }
}
