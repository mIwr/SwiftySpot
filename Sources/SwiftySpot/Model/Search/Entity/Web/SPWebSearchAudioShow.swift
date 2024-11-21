//
//  SPWebSearchPodcast.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2024.
//

import Foundation

public class SPWebSearchAudioShow: SPTypedObj, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case uri
        case name
        case mediaType
        case cover = "coverArt"
        case publisher
        case topics
    }
    
    public let name: String
    public let mediaType: String
    public let cover: SPWebSearchCardImage
    public let publisher: SPWebPublisher?
    public let topics: [SPWebSearchTopic]
    
    public init(uri: String, name: String, mediaType: String, cover: SPWebSearchCardImage, publisher: SPWebPublisher?, topics: [SPWebSearchTopic]) {
        self.name = name
        self.mediaType = mediaType
        self.cover = cover
        self.publisher = publisher
        self.topics = topics
        super.init(uri: uri)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.mediaType = (try? container.decodeIfPresent(String.self, forKey: .mediaType)) ?? ""
        self.cover = (try? container.decodeIfPresent(SPWebSearchCardImage.self, forKey: .cover)) ?? SPWebSearchCardImage(sources: [])
        self.publisher = try? container.decodeIfPresent(SPWebPublisher.self, forKey: .publisher)
        self.topics = (try? container.decodeIfPresent([SPWebSearchTopic].self, forKey: .topics)) ?? []
        if let safeUri = try? container.decodeIfPresent(String.self, forKey: .uri) {
            super.init(uri: safeUri)
        } else {
            super.init(globalID: [], type: .show)
        }
    }
}

extension SPWebSearchAudioShow {
    
    public func asSearchObj() -> SPSearchEntity {
        return SPSearchEntity(uri: uri, name: name, imgUri: cover.biggestImg ?? "", artist: nil, track: nil, album: nil, playlist: nil, genre: nil, show: SPSearchAudioShow(category: mediaType, musicAndTalk: false, publisherName: publisher?.name ?? ""), profile: nil, audiobook: nil, autocomplete: nil, serpMeta: "")
    }
    
}

class SPWebSearchPodcastWrapper: SPWebSearchResultEntryWrapper<SPWebSearchAudioShow> {
    
    static let typeName = "PodcastResponseWrapper"
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        if (typename != SPWebSearchPodcastWrapper.typeName) {
            throw NSError(domain: String(describing: SPWebSearchPodcastWrapper.self), code: -1)
        }
    }
}

/*
 {
             "__typename": "PodcastResponseWrapper",
             "data": {
               "__typename": "Podcast",
               "coverArt": {
                 "extractedColors": {
                   "colorDark": {
                     "hex": "#777777",
                     "isFallback": false
                   }
                 },
                 "sources": [
                   {
                     "height": 64,
                     "url": "https://i.scdn.co/image/ab6765630000f68dd11b93c9e0254d519de6af70",
                     "width": 64
                   },
                   {
                     "height": 300,
                     "url": "https://i.scdn.co/image/ab67656300005f1fd11b93c9e0254d519de6af70",
                     "width": 300
                   },
                   {
                     "height": 640,
                     "url": "https://i.scdn.co/image/ab6765630000ba8ad11b93c9e0254d519de6af70",
                     "width": 640
                   }
                 ]
               },
               "mediaType": "AUDIO",
               "name": "Vital MX",
               "publisher": {
                 "name": "Vital MX"
               },
               "topics": {
                 "items": [
                   {
                     "__typename": "PodcastTopic",
                     "title": "Recreation",
                     "uri": "spotify:genre:0JQ5DAqbMKFLhhtGqqgAsz"
                   },
                   {
                     "__typename": "PodcastTopic",
                     "title": "Спорт",
                     "uri": "spotify:genre:0JQ5DAqbMKFLhhtGqqgAsz"
                   }
                 ]
               },
               "uri": "spotify:show:4iJapCTua9oBZPH1VA6eTk"
             }
           },
 */
