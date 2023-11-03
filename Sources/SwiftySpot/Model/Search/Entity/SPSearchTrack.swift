//
//  SPSearchTrack.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Track search match
public class SPSearchTrack {
    ///Track is explicit flag
    public let explicit: Bool
    ///Track is windowed flag
    public let windowed: Bool
    ///Track album info
    public let album: SPSearchRelatedEntity
    ///Track authors info
    public let artists: [SPSearchRelatedEntity]
    ///TODO
    public let mogef19: Bool
    ///Lyrics flag
    public let lyricsMatch: Bool
    ///Search on demand
    public let onDemand: SPSearchOnDemand?
    
    public var generatedAlbumMeta: SPMetadataAlbum {
        get {
            return SPMetadataAlbum(gid: [], name: album.name, uri: album.uri)
        }
    }
    
    public var generatedArtistsMeta: [SPMetadataArtist] {
        get {
            var res: [SPMetadataArtist] = []
            for artist in artists {
                res.append(SPMetadataArtist(gid: [], name: artist.name, uri: artist.uri))
            }
            return res
        }
    }
    
    public init(explicit: Bool, windowed: Bool, album: SPSearchRelatedEntity, artists: [SPSearchRelatedEntity], mogef19: Bool, lyricsMatch: Bool, onDemand: SPSearchOnDemand?) {
        self.explicit = explicit
        self.windowed = windowed
        self.album = album
        self.artists = artists
        self.mogef19 = mogef19
        self.lyricsMatch = lyricsMatch
        self.onDemand = onDemand
    }
    
    public func asMetaObj(uri: String, name: String) -> SPMetadataTrack {
        let meta = SPMetadataTrack(gid: [], name: name, album: generatedAlbumMeta, artists: generatedArtistsMeta,  durationInMs: 0,  explicit: explicit)
        return meta
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_Track) -> SPSearchTrack {
        let album = SPSearchRelatedEntity.from(protobuf: protobuf.album)
        var artists: [SPSearchRelatedEntity] = []
        for item in protobuf.artists {
            let parsed = SPSearchRelatedEntity.from(protobuf: item)
            artists.append(parsed)
        }
        let onDemand = SPSearchOnDemand.from(protobuf: protobuf.onDemand)
        return SPSearchTrack(explicit: protobuf.explicit, windowed: protobuf.windowed, album: album, artists: artists, mogef19: protobuf.mogef19, lyricsMatch: protobuf.lyricsMatch, onDemand: onDemand)
    }
}
