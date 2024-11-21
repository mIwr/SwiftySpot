//
//  SPWebSearchPlaylist.swift
//  SwiftySpot
//
//  Created by developer on 13.11.2024.
//

import Foundation

public class SPWebSearchPlaylist: SPTypedObj, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case uri
        case name
        case desc = "description"
        case format
        case coversContainer = "images"
        case covers = "items"
        case owner = "ownerV2"
    }
    
    public let name: String
    public let desc: String
    public let format: String
    public let covers: [SPWebSearchCardImage]
    public let owner: SPWebSearchProfile
    
    public init(uri: String, name: String, desc: String, format: String, covers: [SPWebSearchCardImage], owner: SPWebSearchProfile) {
        self.name = name
        self.desc = desc
        self.format = format
        self.covers = covers
        self.owner = owner
        super.init(uri: uri)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.desc = (try? container.decodeIfPresent(String.self, forKey: .desc)) ?? ""
        self.format = (try? container.decodeIfPresent(String.self, forKey: .format)) ?? ""
        if let safeCoversContainer = try? container.decodeIfPresent([String: [SPWebSearchCardImage]].self, forKey: .coversContainer), let safeCovers = safeCoversContainer[CodingKeys.covers.rawValue] {
            self.covers = safeCovers
        } else {
            self.covers = []
        }
        if let safeOwnerContainer = try? container.decodeIfPresent(SPWebSearchProfileWrapper.self, forKey: .owner) {
            self.owner = safeOwnerContainer.data
        } else {
            self.owner = SPWebSearchProfile(name: "", ava: SPWebSearchCardImage(sources: []), username: "", verified: false)
        }
        if let safeUri = try? container.decodeIfPresent(String.self, forKey: .uri) {
            super.init(uri: safeUri)
        } else {
            super.init(globalID: [], type: .playlist)
        }
    }
    
}

extension SPWebSearchPlaylist {
    
    public func asSearchObj() -> SPSearchEntity {
        return SPSearchEntity(uri: uri, name: name, imgUri: covers.first?.biggestImg ?? "", artist: nil, track: nil, album: nil, playlist: SPSearchPlaylist(spotifyOwner: owner.username == "spotify", tracksCount: 0, personalized: false), genre: nil, show: nil, profile: nil, audiobook: nil, autocomplete: nil, serpMeta: "")
    }
    
}

class SPWebSearchPlaylistWrapper: SPWebSearchResultEntryWrapper<SPWebSearchPlaylist> {
    
    static let typeName = "PlaylistResponseWrapper"
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        if (typename != SPWebSearchPlaylistWrapper.typeName) {
            throw NSError(domain: String(describing: SPWebSearchPlaylistWrapper.self), code: -1)
        }
    }
}

/*
 {
             "__typename": "PlaylistResponseWrapper",
             "data": {
               "__typename": "Playlist",
               "attributes": [
                 {
                   "key": "request_id",
                   "value": "ssp~0626cb40222be5f540bf7361bd8a8bb29232"
                 },
                 {
                   "key": "correlation-id",
                   "value": "ssp~0626cb40222be5f540bf7361bd8a8bb29232"
                 }
               ],
               "description": "<a href=spotify:playlist:37i9dQZF1EIXkM8I2bv7zF>Chayanne</a>, <a href=spotify:playlist:37i9dQZF1EIWhEBbHcdFic>Sin Bandera</a> и <a href=spotify:playlist:37i9dQZF1EIYOhsF7u8IY8>Reyli Barba</a>",
               "format": "artist-mix-reader",
               "images": {
                 "items": [
                   {
                     "extractedColors": {
                       "colorDark": {
                         "hex": "#8A7074",
                         "isFallback": false
                       }
                     },
                     "sources": [
                       {
                         "height": null,
                         "url": "https://seed-mix-image.spotifycdn.com/v6/img/artist/4NEYQeEYBUjfaXgDQGvFvu/ru/default",
                         "width": null
                       }
                     ]
                   }
                 ]
               },
               "name": "Franco De Vita: микс",
               "ownerV2": {
                 "__typename": "UserResponseWrapper",
                 "data": {
                   "__typename": "User",
                   "avatar": {
                     "sources": [
                       {
                         "height": 64,
                         "url": "https://i.scdn.co/image/ab67757000003b8255c25988a6ac314394d3fbf5",
                         "width": 64
                       },
                       {
                         "height": 300,
                         "url": "https://i.scdn.co/image/ab6775700000ee8555c25988a6ac314394d3fbf5",
                         "width": 300
                       }
                     ]
                   },
                   "name": "Spotify",
                   "uri": "spotify:user:spotify",
                   "username": "spotify"
                 }
               },
               "uri": "spotify:playlist:37i9dQZF1EIVLbpj75CoUt"
             }
           },
 */
