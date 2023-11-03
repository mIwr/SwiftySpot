//
//  SPSearchAlbum.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Album search match
public class SPSearchAlbum {
    ///Artists-authors
    public let artistNames: [String]
    ///Album type
    public let type: Int
    ///Album release year
    public let releaseYear: UInt
    ///State type
    public let state: Int
    ///Create timestamp
    public let timestamp: Int64
    public let userCountryReleaseIsoTime: String
    
    public init(artistNames: [String], type: Int, releaseYear: UInt, state: Int, timestamp: Int64, userCountryReleaseIsoTime: String) {
        self.artistNames = artistNames
        self.type = type
        self.releaseYear = releaseYear
        self.state = state
        self.timestamp = timestamp
        self.userCountryReleaseIsoTime = userCountryReleaseIsoTime
    }
    
    public func asMetaObj(uri: String, name: String) -> SPMetadataAlbum {
        let meta = SPMetadataAlbum(gid: [], name: name, uri: uri, artists: artistNames.map({ name in
            return SPMetadataArtist(gid: [], name: name)
        }))
        return meta
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_Album) -> SPSearchAlbum {
        return SPSearchAlbum(artistNames: protobuf.artistNames, type: Int(protobuf.type), releaseYear: UInt(protobuf.releaseYear), state: Int(protobuf.state), timestamp: protobuf.timestamp.seconds, userCountryReleaseIsoTime: protobuf.userCountryReleaseIsoTime)
    }
}
