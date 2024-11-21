//
//  SPWebSearchArtist.swift
//  SwiftySpot
//
//  Created by developer on 14.10.2024.
//

import Foundation

public class SPWebSearchArtist: SPTypedObj, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case profileContainer = "profile"
        case uri
        case visualsContainer = "visuals"
        case ava = "avatarImage"
    }
    
    public let name: String
    public let verified: Bool
    public let ava: SPWebSearchCardImage?
    
    public init(uri: String, name: String, verified: Bool = false, ava: SPWebSearchCardImage? = nil) {
        self.name = name
        self.verified = verified
        self.ava = ava
        super.init(uri: uri)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var name = ""
        var verified = false
        var ava: SPWebSearchCardImage? = nil
        if let safeAvaContainer = try? container.decodeIfPresent([String: SPWebSearchCardImage].self, forKey: .visualsContainer), let safeAvaImg = safeAvaContainer[CodingKeys.ava.rawValue] {
            ava = safeAvaImg
        }
        if let safeProfileContainer = try? container.decodeIfPresent(SPWebSearchProfile.self, forKey: .profileContainer) {
            name = safeProfileContainer.name
            verified = safeProfileContainer.verified
        }
        self.name = name
        self.verified = verified
        self.ava = ava
        if let safeUri = try? container.decodeIfPresent(String.self, forKey: .uri) {
            super.init(uri: safeUri)
        } else {
            super.init(globalID: [], type: .artist)
        }
    }
}

extension SPWebSearchArtist {
    public func asSearchObj() -> SPSearchEntity {
        return SPSearchEntity(uri: uri, name: name, imgUri: ava?.biggestImg ?? "", artist: SPSearchArtist(verified: verified), track: nil, album: nil, playlist: nil, genre: nil, show: nil, profile: nil, audiobook: nil, autocomplete: nil, serpMeta: "")
    }
    
    public func asMetaObj() -> SPMetadataArtist {
        return SPMetadataArtist(gid: globalID, name: name, uri: uri)
    }
}

class SPWebSearchArtistWrapper: SPWebSearchResultEntryWrapper<SPWebSearchArtist> {
    
    static let typeName = "ArtistResponseWrapper"
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        if (typename != SPWebSearchArtistWrapper.typeName) {
            throw NSError(domain: String(describing: SPWebSearchArtistWrapper.self), code: -1)
        }
    }
}

class SPWebSearchArtistsContainer: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    public let items: [SPWebSearchArtist]
    
    public init(items: [SPWebSearchArtist]) {
        self.items = items
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([SPWebSearchArtist].self, forKey: .items)
    }
}
