//
//  SPSearchProfile.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Profile search match info
public class SPSearchProfile {
  ///Profile verified flag
  public let verified: Bool
  
  public init(verified: Bool) {
    self.verified = verified
  }
  
  static func from(protobuf: Com_Spotify_Searchview_Proto_Profile) -> SPSearchProfile {
    return SPSearchProfile(verified: protobuf.verified)
  }
}
