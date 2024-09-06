//
//  SPSearchArtist.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

extension SPSearchArtist {
    
    public init(verified: Bool) {
        self.verified = verified
    }
    
    public func asMetaObj(uri: String, name: String) -> SPMetadataArtist {
        return SPMetadataArtist(gid: [], name: name, uri: uri)
    }
}
