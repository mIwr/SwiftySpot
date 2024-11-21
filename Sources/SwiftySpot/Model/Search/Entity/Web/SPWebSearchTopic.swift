//
//  SPWebSearchTopic.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2024.
//

import Foundation

public class SPWebSearchTopic: SPTypedObj, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case uri
        case title
    }
    
    public let title: String
    
    public init(uri: String, title: String) {
        self.title = title
        super.init(uri: uri)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        let uri = try container.decode(String.self, forKey: .uri)
        super.init(uri: uri)
    }
    
}

class SPWebSearchTopicsContainer: Decodable {
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    let items: [SPWebSearchTopic]
    
    init(items: [SPWebSearchTopic]) {
        self.items = items
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([SPWebSearchTopic].self, forKey: .items)
    }
    
}

/*
 "__typename": "PodcastTopic",
 "title": "Recreation",
 "uri": "spotify:genre:0JQ5DAqbMKFLhhtGqqgAsz"
 */
