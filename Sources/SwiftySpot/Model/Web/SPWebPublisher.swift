//
//  SPWebPublisher.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2024.
//

import Foundation

public class SPWebPublisher: Decodable {
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
}
