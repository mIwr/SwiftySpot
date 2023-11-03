//
//  SPSearchAccess.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Search object access settings
public class SPSearchAccess {
  ///TODO
  public let signifier: String
  ///Unlocked for play
  public let unlocked: Bool

  public init(signifier: String, unlocked: Bool) {
    self.signifier = signifier
    self.unlocked = unlocked
  }

  static func from(protobuf: Com_Spotify_Searchview_Proto_Access) -> SPSearchAccess {
    return SPSearchAccess(signifier: protobuf.signifier, unlocked: protobuf.unlocked)
  }
}
