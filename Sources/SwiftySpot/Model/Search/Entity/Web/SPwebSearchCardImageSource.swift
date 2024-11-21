//
//  SPwebSearchCardImageSource.swift
//  SwiftySpot
//
//  Created by developer on 14.10.2024.
//

import Foundation

public class SPwebSearchCardImageSource: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
    }
    
    public let width: Int
    public let height: Int
    public let url: String
    
    public init(width: Int, height: Int, url: String) {
        self.width = width
        self.height = height
        self.url = url
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = (try? container.decodeIfPresent(Int.self, forKey: .width)) ?? 1
        self.height = (try container.decodeIfPresent(Int.self, forKey: .height)) ?? 1
        self.url = try container.decode(String.self, forKey: .url)
    }
    
}
