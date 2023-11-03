//
//  SPSearchSegment.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Search query segment
public class SPSearchSegment {
  ///Query segment value
  public let segVal: String
  ///Match flag
  public let match: Bool

  public init(segVal: String, match: Bool) {
    self.segVal = segVal
    self.match = match
  }

  static func from(protobuf: Com_Spotify_Searchview_Proto_Segment) -> SPSearchSegment {
    return SPSearchSegment(segVal: protobuf.value, match: protobuf.matched)
  }
}
