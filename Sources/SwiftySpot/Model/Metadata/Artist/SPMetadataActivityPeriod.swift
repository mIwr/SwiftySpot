//
//  SPMetadataActivityPeriod.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

///Artist activity period meta info
public class SPMetadataActivityPeriod {
  ///Period start year
  public let startYear: Int32
  ///Period end year
  public let endYear: Int32?
  ///Period decade
  public let decade: Int32
  
  public init(startYear: Int32, endYear: Int32? = nil, decade: Int32) {
    self.startYear = startYear
    self.endYear = endYear
    self.decade = decade
  }
  
  static func from(protobuf: Spotify_Metadata_ActivityPeriod) -> SPMetadataActivityPeriod {
    return SPMetadataActivityPeriod(startYear: protobuf.startYear, endYear: protobuf.endYear, decade: protobuf.decade)
  }
}
