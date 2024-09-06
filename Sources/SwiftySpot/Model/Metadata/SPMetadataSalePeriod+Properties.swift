//
//  SPMetadataSalePeriod.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

extension SPMetadataSalePeriod {

  ///Sale period start timestamp
  public var startTsUTC: Int64 {
    get {
      return start.timestamp
    }
  }
  
  public var startDt: Date {
    get {
      let dt = Date(timeIntervalSince1970: TimeInterval(startTsUTC))
      return dt
    }
  }
  ///Sale period end timestamp
  public var endTsUTC: Int64 {
    get {
      return end.timestamp
    }
  }
  public var endDt: Date {
    get {
      let dt = Date(timeIntervalSince1970: TimeInterval(endTsUTC))
      return dt
    }
  }
}
