//
//  SPWebDuration.swift
//  SwiftySpot
//
//  Created by developer on 13.11.2024.
//

import Foundation

struct SPWebDuration: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case totalMillis = "totalMilliseconds"
    }
    
    let totalMillis: UInt32
    
    init(totalMillis: UInt32) {
        self.totalMillis = totalMillis
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalMillis = try container.decode(UInt32.self, forKey: .totalMillis)
    }
}
