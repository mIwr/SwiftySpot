//
//  SPWebSearchProfile.swift
//  SwiftySpot
//
//  Created by developer on 14.10.2024.
//

import Foundation

public class SPWebSearchProfile: SPBaseObj, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case uri
        case name
        case displayName
        case ava = "avatar"
        case username
        case verified
    }
    
    public let name: String
    public let ava: SPWebSearchCardImage
    public let username: String
    public var uri: String? {
        get {
            if (username.isEmpty) {
                return nil
            }
            return SPNavigateUriUtil.generateAlbumUri(id: username)
        }
    }
    public let verified: Bool
    
    public init(name: String, ava: SPWebSearchCardImage, username: String, verified: Bool = false) {
        self.name = name
        self.ava = ava
        self.username = username
        self.verified = verified
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = (try? container.decodeIfPresent(String.self, forKey: .name)) ?? ""
        if name.isEmpty, let safeDisplayName = try? container.decodeIfPresent(String.self, forKey: .displayName) {
            self.name = safeDisplayName
        } else {
            self.name = name
        }
        self.ava = (try? container.decodeIfPresent(SPWebSearchCardImage.self, forKey: .ava)) ?? SPWebSearchCardImage(sources: [])
        var username = (try? container.decodeIfPresent(String.self, forKey: .username)) ?? ""
        if username.isEmpty, let safeID = try? container.decodeIfPresent(String.self, forKey: .id) {
            username = safeID
        }
        if (username.isEmpty) {
            let uri = (try? container.decodeIfPresent(String.self, forKey: .uri)) ?? ""
            username = SPNavigateUriUtil.extractUsernameFromUserUri(uri)
        }
        self.username = username
        self.verified = (try? container.decodeIfPresent(Bool.self, forKey: .verified)) ?? false
    }
    
}

extension SPWebSearchProfile {
    public func asSearchObj() -> SPSearchEntity {
        return SPSearchEntity(uri: uri ?? "", name: name, imgUri: ava.biggestImg ?? "", artist: nil, track: nil, album: nil, playlist: nil, genre: nil, show: nil, profile: SPSearchProfile(verified: verified), audiobook: nil, autocomplete: nil, serpMeta: "")
    }
}

class SPWebSearchProfileWrapper: SPWebSearchResultEntryWrapper<SPWebSearchProfile> {
    
    static let typeName = "UserResponseWrapper"
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        if (typename != SPWebSearchProfileWrapper.typeName) {
            throw NSError(domain: String(describing: SPWebSearchProfileWrapper.self), code: -1)
        }
    }
}

/*
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
     "id": "spotify",
     "name": "Spotify",
     "displayName": "Spotify",
     "uri": "spotify:user:spotify",
     "username": "spotify"
   }
 },
 */
