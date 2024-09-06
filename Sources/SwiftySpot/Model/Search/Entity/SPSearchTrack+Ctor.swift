//
//  SPSearchTrack.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

extension SPSearchTrack {
    
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
    
    public init(explicit: Bool, windowed: Bool, album: SPRelatedEntity, artists: [SPRelatedEntity], mogef19: Bool, lyricsMatch: Bool, onDemand: SPOnDemand?) {
        self.explicit = explicit
        self.windowed = windowed
        self.album = album
        self.artists = artists
        self.mogef19 = mogef19
        self.lyricsMatch = lyricsMatch
        self.onDemand = onDemand ?? SPOnDemand()
    }
    
    public func asMetaObj(uri: String, name: String) -> SPMetadataTrack {
        let meta = SPMetadataTrack(gid: [], name: name, album: generatedAlbumMeta, artists: generatedArtistsMeta,  durationInMs: 0,  explicit: explicit)
        return meta
    }
}
