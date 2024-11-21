//
//  SPWebSearchAlbum.swift
//  SwiftySpot
//
//  Created by developer on 16.10.2024.
//

import Foundation

public class SPWebSearchAlbum: SPTypedObj, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case uri
        case name
        case type
        case playableBanReason = "reason"
        case artistsContainer = "artists"
        case artists = "items"
        case cover = "coverArt"
        case releaseDate = "date"
        case playability = "playability"
    }
    
    public let type: String
    public let name: String
    public let artists: [SPWebSearchArtist]
    public let cover: SPWebSearchCardImage
    public let releaseDate: SPDateTime
    public let playability: SPWebPlayability
    
    public init(uri: String, type: String, name: String, releaseYear: String, artists: [SPWebSearchArtist], cover: SPWebSearchCardImage, releaseDate: SPDateTime, playability: SPWebPlayability) {
        self.type = type
        self.name = name
        self.releaseDate = releaseDate
        self.artists = artists
        self.cover = cover
        self.playability = playability
        super.init(uri: uri)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = (try? container.decodeIfPresent(String.self, forKey: .type)) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.releaseDate = (try? container.decodeIfPresent(SPDateTime.self, forKey: .releaseDate)) ?? SPDateTime(year: 1970)
        self.playability = (try? container.decodeIfPresent(SPWebPlayability.self, forKey: .playability)) ?? SPWebPlayability(playable: false, reason: "")
        if let safeArtistsContainer = try? container.decodeIfPresent(SPWebSearchArtistsContainer.self, forKey: .artistsContainer) {
            self.artists = safeArtistsContainer.items
        } else {
            self.artists = []
        }
        self.cover = (try? container.decodeIfPresent(SPWebSearchCardImage.self, forKey: .cover)) ?? SPWebSearchCardImage(sources: [])
        if let safeUri = try? container.decodeIfPresent(String.self, forKey: .uri) {
            super.init(uri: safeUri)
        } else {
            super.init(globalID: [], type: .album)
        }
    }
}

extension SPWebSearchAlbum {
    
    public func asSearchObj() -> SPSearchEntity {
        return SPSearchEntity(uri: uri, name: name, imgUri: cover.biggestImg ?? "", artist: nil, track: nil, album: SPSearchAlbum(artistNames: artists.map({ artist in
            return artist.name
        }), type: 0, releaseYear: UInt(releaseDate.year), state: 0, timestamp: 0, userCountryReleaseIsoTime: ""), playlist: nil, genre: nil, show: nil, profile: nil, audiobook: nil, autocomplete: nil, serpMeta: "")
    }
    
    public func asMetaObj() -> SPMetadataAlbum {
        var restrictions: [SPMetadataRestriction] = []
        if (!playability.playable) {
            var restriction = SPMetadataRestriction()
            restriction.type = 3
            restrictions.append(restriction)
        }
        return SPMetadataAlbum(gid: globalID, name: name, uri: uri, artists: artists.map({ artist in
            return artist.asMetaObj()
        }), type: .album, releaseTsUTC: releaseDate.timestampSince1970, restrictions: restrictions)
    }
}

class SPWebSearchAlbumWrapper: SPWebSearchResultEntryWrapper<SPWebSearchAlbum> {
    
    static let typeName = "AlbumResponseWrapper"
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        if (typename != SPWebSearchAlbumWrapper.typeName) {
            throw NSError(domain: String(describing: SPWebSearchAlbumWrapper.self), code: -1)
        }
    }
}

/*
 {
                         "__typename": "AlbumResponseWrapper",
                         "data": {
                             "__typename": "Album",
                             "artists": {
                                 "items": [
                                     {
                                         "profile": {
                                             "name": "Weltenwandler"
                                         },
                                         "uri": "spotify:artist:0aE08eLwPlJwCqDLS7Oz8f"
                                     }
                                 ]
                             },
                             "coverArt": {
                                 "extractedColors": {
                                     "colorDark": {
                                         "hex": "#188070",
                                         "isFallback": false
                                     }
                                 },
                                 "sources": [
                                     {
                                         "height": 300,
                                         "url": "https://i.scdn.co/image/ab67616d00001e026cff303840047e1400bd403f",
                                         "width": 300
                                     },
                                     {
                                         "height": 64,
                                         "url": "https://i.scdn.co/image/ab67616d000048516cff303840047e1400bd403f",
                                         "width": 64
                                     },
                                     {
                                         "height": 640,
                                         "url": "https://i.scdn.co/image/ab67616d0000b2736cff303840047e1400bd403f",
                                         "width": 640
                                     }
                                 ]
                             },
                             "date": {
                                 "year": 2012
                             },
                             "name": "Glasperlenspiel",
                             "playability": {
                                 "playable": false,
                                 "reason": "COUNTRY_RESTRICTED"
                             },
                             "type": "EP",
                             "uri": "spotify:album:2zMwHooXMc1lAPkHu0ACVh"
                         }
                     },
 */
