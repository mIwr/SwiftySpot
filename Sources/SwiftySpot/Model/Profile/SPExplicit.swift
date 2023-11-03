//
//  SPExplicit.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

///Profile explicit settings
public class SPExplicit: Decodable {

  enum CodingKeys: String, CodingKey {
    case enabled = "filter_enabled"
    case locked = "filter_locked"
  }
  ///Explicit block enabled flag
  public let enabled: Bool
  ///Excplict block change lock enabled falg
  public let locked: Bool

  public init(enabled: Bool, locked: Bool) {
    self.enabled = enabled
    self.locked = locked
  }
}
