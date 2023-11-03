//
//  SPMetadataContentRating.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

///Content rating meta info
public class SPMetadataContentRating {
  ///Country code
  public let country: String
  ///Rating rags
  public let tags: [String]
  
  public init(country: String, tags: [String]) {
    self.country = country
    self.tags = tags
  }
  
  static func from(protobuf: Spotify_Metadata_ContentRating) -> SPMetadataContentRating {
    return SPMetadataContentRating(country: protobuf.country, tags: protobuf.tags)
  }
}
