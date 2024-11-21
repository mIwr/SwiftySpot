//
//  SPWebPlayability.swift
//  SwiftySpot
//
//  Created by developer on 13.11.2024.
//

import Foundation

public class SPWebPlayability: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case playable
        case reason
    }
    
    public let playable: Bool
    public let reason: String
    
    public init(playable: Bool, reason: String) {
        self.playable = playable
        self.reason = reason
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.playable = (try? container.decodeIfPresent(Bool.self, forKey: .playable)) ?? false
        self.reason = (try? container.decode(String.self, forKey: .reason)) ?? ""
    }
    
}
