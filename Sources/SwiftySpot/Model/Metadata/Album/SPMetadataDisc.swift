//
//  SPMetadataDisc.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

///Album disc meta info
public class SPMetadataDisc {
  ///Order number
  public let number: Int32
  ///Disc name
  public let name: String
  ///Brief meta info about tracks
  public let tracks: [SPMetadataTrack]
  
  public init(number: Int32, name: String, tracks: [SPMetadataTrack]) {
    self.number = number
    self.name = name
    self.tracks = tracks
  }
  
  static func from(protobuf: SPMetaDisc) -> SPMetadataDisc {
    var tracks: [SPMetadataTrack] = []
    for item in protobuf.tracks {
      let parsed = SPMetadataTrack.from(protobuf: item, uri: "")
      tracks.append(parsed)
    }
    return SPMetadataDisc(number: protobuf.number, name: protobuf.name, tracks: tracks)
  }
}
