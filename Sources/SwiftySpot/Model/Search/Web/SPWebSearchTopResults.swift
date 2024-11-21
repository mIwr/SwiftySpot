//
//  SPWebSearchTopResults.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2024.
//

import Foundation

public class SPWebSearchTopResults: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case featured
        case items = "itemsV2"
    }
    
    //featured array
    ///Search top results
    public let items: [SPSearchEntity]
    
    public init(items: [SPSearchEntity]) {
        self.items = items
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topResults = try container.decode([SPWebSearchTopResult].self, forKey: .items)
        self.items = topResults.map({ res in
            return res.item
        })
    }
    
}

class SPWebSearchTopResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case item
    }
    
    let item: SPSearchEntity
    
    init(item: SPSearchEntity) {
        self.item = item
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrapperMeta = try container.decode(SPWebSearchResultEntryMetaWrapper.self, forKey: .item)
        switch(wrapperMeta.typename) {
        case SPWebSearchArtistWrapper.typeName:
            let artistWrapper = try container.decode(SPWebSearchArtistWrapper.self, forKey: .item)
            self.item = artistWrapper.data.asSearchObj()
            break
        case SPWebSearchAlbumWrapper.typeName:
            let albumWrapper = try container.decode(SPWebSearchAlbumWrapper.self, forKey: .item)
            self.item = albumWrapper.data.asSearchObj()
            break
        case SPWebSearchPlaylistWrapper.typeName:
            let playlistWrapper = try container.decode(SPWebSearchPlaylistWrapper.self, forKey: .item)
            self.item = playlistWrapper.data.asSearchObj()
            break
        case SPWebSearchTrackWrapper.typeName:
            let trackWrapper = try container.decode(SPWebSearchTrackWrapper.self, forKey: .item)
            self.item = trackWrapper.data.asSearchObj()
            break
        case SPWebSearchProfileWrapper.typeName:
            let userWrapper = try container.decode(SPWebSearchProfileWrapper.self, forKey: .item)
            self.item = userWrapper.data.asSearchObj()
            break
        case SPWebSearchPodcastWrapper.typeName:
            let showWrapper = try container.decode(SPWebSearchPodcastWrapper.self, forKey: .item)
            self.item = showWrapper.data.asSearchObj()
            break
        default:
            print("Unknown wrapper type name", wrapperMeta.typename)
            self.item = SPSearchEntity(uri: "", name: "", imgUri: "", artist: nil, track: nil, album: nil, playlist: nil, genre: nil, show: nil, profile: nil, audiobook: nil, autocomplete: nil, serpMeta: "")
            break
        }
    }
}
