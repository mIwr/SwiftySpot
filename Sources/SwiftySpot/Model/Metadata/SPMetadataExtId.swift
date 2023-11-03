//
//  SPMetadataExtId.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

///External ID meta info
public class SPMetadataExtId {
    public let id: String
    public let type: String
    
    public init(id: String, type: String) {
        self.id = id
        self.type = type
    }
    
    static func from(protobuf: Spotify_Metadata_ExternalId) -> SPMetadataExtId {
        return SPMetadataExtId(id: protobuf.id, type: protobuf.type)
    }
}
