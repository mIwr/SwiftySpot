//
//  SPSearchRelated.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Related search query
public class SPSearchRelated: SPTypedObj {
    ///Search query
    public let text: String
    
    public init(text: String, uri: String) {
        self.text = text
        super.init(uri: uri)
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_RelatedSearch) -> SPSearchRelated {
        return SPSearchRelated(text: protobuf.text, uri: protobuf.uri)
    }
}
