//
//  SPMetadataSalePeriod.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

///Sale period meta info
public class SPMetadataSalePeriod {
  ///Restrictions info
  public let restrictions: [SPMetadataRestriction]
  ///Sale period start timestamp
  public let startTsUTC: Int64
  public var start: Date {
    get {
      let dt = Date(timeIntervalSince1970: TimeInterval(startTsUTC))
      return dt
    }
  }
  ///Sale period end timestamp
  public let endTsUTC: Int64
  public var end: Date {
    get {
      let dt = Date(timeIntervalSince1970: TimeInterval(endTsUTC))
      return dt
    }
  }
  
  public init(restrictions: [SPMetadataRestriction], startTsUTC: Int64, endTsUTC: Int64) {
    self.restrictions = restrictions
    self.startTsUTC = startTsUTC
    self.endTsUTC = endTsUTC
  }
  
  static func from(protobuf: Spotify_Metadata_SalePeriod) -> SPMetadataSalePeriod {
    var restrictions: [SPMetadataRestriction] = []
    for item in protobuf.restrictions {
      let parsed = SPMetadataRestriction.from(protobuf: item)
      restrictions.append(parsed)
    }
    var dt = SPMetadataDate.from(protobuf: protobuf.start)
    let startTs = dt.timestamp
    dt = SPMetadataDate.from(protobuf: protobuf.end)
    let endTs = dt.timestamp
    return SPMetadataSalePeriod(restrictions: restrictions, startTsUTC: startTs, endTsUTC: endTs)
  }
}
