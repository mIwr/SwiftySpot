//
//  SPMetadataAvailability.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

extension SPMetadataAvailability {
  ///Availability start timestamp
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
}
