//
//  SPWebSearchCardImage.swift
//  SwiftySpot
//
//  Created by developer on 14.10.2024.
//

import Foundation

public class SPWebSearchCardImage: Decodable {
    
    enum CodingKeys: String, CodingKey {
      case sources
      case extractedColors
    }
    
    public let sources: [SPwebSearchCardImageSource]
    public let extractedColors: SPWebSearchCardImageColors?
    
    public var biggestImg: String? {
        get {
            var imgUrl: String? = nil
            var maxSquare = 0
            for source in sources {
                let square = source.width * source.height
                if (square < maxSquare) {
                    continue
                }
                maxSquare = square
                imgUrl = source.url
            }
            return imgUrl
        }
    }
    
    public var smallestImg: String? {
        get {
            var imgUrl: String? = nil
            var maxSquare = Int.max
            for source in sources {
                let square = source.height * source.width
                if (square > maxSquare) {
                    continue
                }
                maxSquare = square
                imgUrl = source.url
            }
            return imgUrl
        }
    }
    
    public init(sources: [SPwebSearchCardImageSource], extractedColors: SPWebSearchCardImageColors? = nil) {
        self.extractedColors = extractedColors
        self.sources = sources
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sources = try container.decode([SPwebSearchCardImageSource].self, forKey: .sources)
        self.extractedColors = nil
    }
}
