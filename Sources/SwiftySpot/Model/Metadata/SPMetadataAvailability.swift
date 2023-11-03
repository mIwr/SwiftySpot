//
//  SPMetadataAvailability.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

///Availability meta info
public class SPMetadataAvailability {
  ///Profile product types requirements
  public let catalogue: [String]
  ///Availability start timestamp
  public let startTsUTC: Int64
  public var start: Date {
    get {
      let dt = Date(timeIntervalSince1970: TimeInterval(startTsUTC))
      return dt
    }
  }
  
  public init(catalogue: [String], startTsUTC: Int64) {
    self.catalogue = catalogue
    self.startTsUTC = startTsUTC
  }
  
  static func from(protobuf: Spotify_Metadata_Availability) -> SPMetadataAvailability {
    let dt = SPMetadataDate.from(protobuf: protobuf.start)
    let ts = dt.timestamp
    return SPMetadataAvailability(catalogue: protobuf.catalogueStr, startTsUTC: ts)
  }
}
