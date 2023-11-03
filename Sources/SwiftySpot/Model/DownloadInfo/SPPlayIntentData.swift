//
//  SPPlayIntentData.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Audio play intent data
public class SPPlayIntentData {
  ///Audio file obfuscated decryption key
  public let obfuscatedKey: [UInt8]
  ///TODO
  public let b4Seq: [UInt8]

  public init(obfuscatedKey: [UInt8], b4Seq: [UInt8]) {
    self.obfuscatedKey = obfuscatedKey
    self.b4Seq = b4Seq
  }

  static func from(protobuf: Spotify_Playplay_Proto_PlayIntentResponse) -> SPPlayIntentData {
    return SPPlayIntentData(obfuscatedKey: [UInt8].init(protobuf.obfuscatedKey), b4Seq: [UInt8].init(protobuf.b4Seq))
  }
}
