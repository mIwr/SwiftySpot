//
//  SPSearchRelatedEntity.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Related entity for search match
public class SPSearchRelatedEntity: SPTypedObj {
    ///Entity name
    public let name: String
    
    public init(uri: String, name: String) {
        self.name = name
        super.init(uri: uri)
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_RelatedEntity) -> SPSearchRelatedEntity {
        return SPSearchRelatedEntity(uri: protobuf.uri, name: protobuf.name)
    }
}
