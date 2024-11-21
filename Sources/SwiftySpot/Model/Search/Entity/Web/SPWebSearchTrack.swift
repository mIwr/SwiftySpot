//
//  SPWebSearchTrack.swift
//  SwiftySpot
//
//  Created by developer on 13.11.2024.
//

import Foundation

public class SPWebSearchTrack: SPTypedObj, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case uri
        case name
        case album = "albumOfTrack"
        case artists
        case durationInMs = "duration"
        case playability
    }
    
    public let name: String
    public let album: SPWebSearchAlbum?
    public let artists: [SPWebSearchArtist]
    public let durationInMs: UInt32
    public let playability: SPWebPlayability
    
    public init(uri: String, name: String, album: SPWebSearchAlbum?, artists: [SPWebSearchArtist], durationInMs: UInt32, playability: SPWebPlayability) {
        self.name = name
        self.album = album
        self.artists = artists
        self.durationInMs = durationInMs
        self.playability = playability
        super.init(uri: uri)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.album = try? container.decodeIfPresent(SPWebSearchAlbum.self, forKey: .album)
        if let safeArtistsContainer = try? container.decodeIfPresent(SPWebSearchArtistsContainer.self, forKey: .artists) {
            self.artists = safeArtistsContainer.items
        } else {
            self.artists = []
        }
        if let safeDurationContainer = try? container.decodeIfPresent(SPWebDuration.self, forKey: .durationInMs) {
            self.durationInMs = safeDurationContainer.totalMillis
        } else {
            self.durationInMs = 0
        }
        self.playability = (try? container.decodeIfPresent(SPWebPlayability.self, forKey: .playability)) ?? SPWebPlayability(playable: false, reason: "")
        let id = (try? container.decodeIfPresent(String.self, forKey: .id)) ?? ""
        let uri = (try? container.decodeIfPresent(String.self, forKey: .uri)) ?? ""
        if (!id.isEmpty) {
            super.init(id: id, entityType: .track)
        } else if (!uri.isEmpty) {
            super.init(uri: uri)
        } else {
            super.init(globalID: [], type: .track)
        }
    }
}

extension SPWebSearchTrack {
    
    public func asSearchObj() -> SPSearchEntity {
        return SPSearchEntity(uri: uri, name: name, imgUri: album?.cover.biggestImg ?? "", artist: nil, track: SPSearchTrack(explicit: false, windowed: false, album: SPRelatedEntity(uri: album?.uri ?? "", name: album?.name ?? name), artists: artists.map({ artist in
            return SPRelatedEntity(uri: artist.uri, name: artist.name)
        }), mogef19: false, lyricsMatch: false, onDemand: nil), album: nil, playlist: nil, genre: nil, show: nil, profile: nil, audiobook: nil, autocomplete: nil, serpMeta: "")
    }
    
    public func asMetaObj() -> SPMetadataTrack {
        var restrictions: [SPMetadataRestriction] = []
        if (!playability.playable) {
            var restriction = SPMetadataRestriction()
            restriction.type = 3
            restrictions.append(restriction)
        }
        return SPMetadataTrack(gid: globalID, name: name, uri: uri, album: album?.asMetaObj(), artists: artists.map({ artist in
            return artist.asMetaObj()
        }), durationInMs: Int32(durationInMs), restrictions: restrictions)
    }
    
}

class SPWebSearchTrackWrapper: SPWebSearchResultEntryWrapper<SPWebSearchTrack> {
    
    static let typeName = "TrackResponseWrapper"
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        if (typename != SPWebSearchTrackWrapper.typeName) {
            throw NSError(domain: String(describing: SPWebSearchTrackWrapper.self), code: -1)
        }
    }
}

/*
 {
             "item": {
               "__typename": "TrackResponseWrapper",
               "data": {
                 "__typename": "Track",
                 "albumOfTrack": {
                   "coverArt": {
                     "extractedColors": {
                       "colorDark": {
                         "hex": "#284048",
                         "isFallback": false
                       }
                     },
                     "sources": [
                       {
                         "height": 300,
                         "url": "https://i.scdn.co/image/ab67616d00001e02a50fc99f845b6796885b4fe5",
                         "width": 300
                       },
                       {
                         "height": 64,
                         "url": "https://i.scdn.co/image/ab67616d00004851a50fc99f845b6796885b4fe5",
                         "width": 64
                       },
                       {
                         "height": 640,
                         "url": "https://i.scdn.co/image/ab67616d0000b273a50fc99f845b6796885b4fe5",
                         "width": 640
                       }
                     ]
                   },
                   "id": "2mOV6M0b0fG0dC2DD6z2ir",
                   "name": "Родник",
                   "uri": "spotify:album:2mOV6M0b0fG0dC2DD6z2ir"
                 },
                 "artists": {
                   "items": [
                     {
                       "profile": {
                         "name": "Zambezi"
                       },
                       "uri": "spotify:artist:4mXtuH5JEtxW61gxSoUk21"
                     },
                     {
                       "profile": {
                         "name": "Типси Тип"
                       },
                       "uri": "spotify:artist:7jprx8lPHYsj3CP4J8MyhU"
                     }
                   ]
                 },
                 "associations": {
                   "associatedVideos": {
                     "totalCount": 0
                   }
                 },
                 "contentRating": {
                   "label": "NONE"
                 },
                 "duration": {
                   "totalMilliseconds": 193593
                 },
                 "id": "6K3q2EDYcD6rCv9uk7sBrW",
                 "name": "Vita",
                 "playability": {
                   "playable": false,
                   "reason": "COUNTRY_RESTRICTED"
                 },
                 "uri": "spotify:track:6K3q2EDYcD6rCv9uk7sBrW"
               }
             },
             "matchedFields": []
           },
 */
